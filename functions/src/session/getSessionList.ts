import {onRequest} from "firebase-functions/v2/https";
import {db} from "../firebase";

export const getSessionList = onRequest({
  cors: true, memory: "1GiB", // ✅ 또는 "1GB"
  region: "asia-northeast3",
}, async (req, res: any) => {
  if (req.method !== "GET") {
    return res.status(405).json({
      success: false,
      message: "Method Not Allowed",
    });
  }

  try {
    console.time("전체 실행");

    // await verifyAuth(req);

    const threeDaysAgo = new Date(Date.now() - 3 * 24 * 60 * 60 * 1000);


    console.time("세션 쿼리");
    const snapshot = await db.collection("sessions")
      .where("isPrivate", "!=", true)                  // 🔸 비공개 세션 제외
      .where("updatedAt", ">=", threeDaysAgo)                // 🔸 최근 3일
      .orderBy("updatedAt", "desc")                      // 🔸 최신순
      .limit(50)
      .get();
    console.timeEnd("세션 쿼리");

    const now = new Date();
    const twelveHoursAgo = new Date(now.getTime() - 12 * 60 * 60 * 1000);

    console.time("세션 리스트 매핑");
    const list = await Promise.all(snapshot.docs.map(async (doc) => {
      console.time(`세션 ${doc.id}`);
      const data = doc.data();

      // 1. participants 불러오기
      const participantsSnap = await doc.ref.collection("participants").get();
      const allParticipants = participantsSnap.docs.map((d) => d.data());

      const activeParticipants = allParticipants.filter((p) => {
        const raw = p.updatedAt;
        if (!raw) return false;

        const updatedAt: Date =
          typeof raw.toDate === "function" ? raw.toDate() : new Date(raw);

        return updatedAt >= twelveHoursAgo;
      });

      // 🔹 모든 트랙을 최신순으로 가져오기 (최대 10개)
      const tracksSnap = await doc.ref
        .collection("tracks")
        .orderBy("createdAt", "desc")
        .limit(10) // 성능상 안전한 범위
        .get();

      const now = new Date();
      let selectedTrack = null;

      for (const trackDoc of tracksSnap.docs) {
        const track = trackDoc.data();
        const startAt = track.startAt.toDate?.() ?? new Date(track.startAt);
        const endAt = track.endAt.toDate?.() ?? new Date(track.endAt);

        const isStream = track.duration === 0 && startAt.getTime() === endAt.getTime();

        if (
          (isStream && now > startAt) || // 스트리밍 트랙이 현재보다 과거에 시작됨
          (now > startAt && now < endAt) // 일반 트랙이 현재 시간에 재생 중
        ) {
          selectedTrack = track;
          break; // ✅ 현재 재생 중인 트랙이면 더 볼 필요 없음
        }
      }

      // fallback: 가장 최근 트랙
      if (!selectedTrack && tracksSnap.docs.length > 0) {
        selectedTrack = tracksSnap.docs[0].data();
      }

      console.timeEnd(`세션 ${doc.id}`);
      return {
        ...data,
        participantCount: activeParticipants.length,
        trackList: selectedTrack ? [selectedTrack] : [], // ✅ 1건만 리스트로 포함
      };
    }));
    console.timeEnd("세션 리스트 매핑");

    console.timeEnd("전체 실행");
    return res.status(200).json({
      success: true,
      message: "세션 리스트 조회 완료",
      data: list,
    });
  } catch (error) {
    console.error("❌ 세션 리스트 조회 실패:", error);
    return res.status(500).json({
      success: false,
      message: error ?? "Unauthorized",
    });
  }
});
