import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/v2/https";
import {verifyAuth} from "../../utils/auth";
import {db} from "../../firebase";

export const addTrack = onRequest({cors: true}, async (req, res: any) => {
  if (req.method !== "POST") {
    return res.status(200).json({
      success: false,
      message: "허용되지 않은 요청 방식입니다.",
    });
  }

  try {
    const decoded = await verifyAuth(req); // 🔐 인증 유효성 검사
    const uid = decoded.uid;
    const {sessionId, track} = req.body;

    if (!sessionId || !track) {
      return res.status(200).json({
        success: false,
        message: "sessionId와 track 정보는 필수입니다.",
      });
    }

    const sessionRef = db.collection("sessions").doc(sessionId);
    const participantRef = sessionRef.collection("participants").doc(uid);

    // ✅ 참여자 활동 시간 갱신
    await participantRef.update({
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    const tracksCol = sessionRef.collection("tracks");
    const now = new Date();

    // ✅ 현재 재생 중인 트랙 조회
    const currentSnap = await tracksCol
      .where("startAt", "<=", admin.firestore.Timestamp.fromDate(now))
      .where("endAt", ">", admin.firestore.Timestamp.fromDate(now))
      .limit(1)
      .get();

    let baseTime = now;
    let currentTrackId: string | null = null;

    if (!currentSnap.empty) {
      const doc = currentSnap.docs[0];
      baseTime = doc.data().endAt.toDate();
      currentTrackId = doc.id;
    }

    // ✅ baseTime 이후 트랙 목록
    const afterSnap = await tracksCol
      .where("startAt", ">=", admin.firestore.Timestamp.fromDate(baseTime))
      .get();

    const futureTracks = afterSnap.docs
      .filter(doc => doc.id !== currentTrackId)
      .map(doc => ({
        id: doc.id,
        data: doc.data(),
      }));

    // ✅ 새 트랙 ID 및 정보 구성
    const newTrackId = `${Date.now()}-${Math.random().toString(36).substr(2, 8)}`;
    const addedBy = {
      uid,
      nickname: track.addedBy?.nickname ?? "알 수 없음",
      avatarUrl: track.addedBy?.avatarUrl ?? "",
    };

    const newTrack = {
      ...track,
      id: newTrackId, // ✅ 응답에 포함되도록 ID 명시
      addedBy,
      createdAt: admin.firestore.Timestamp.now(),
    };

    const reorderList = [...futureTracks, {id: newTrackId, data: newTrack}]
      .sort((a, b) =>
        a.data.createdAt.toDate().getTime() -
        b.data.createdAt.toDate().getTime(),
      );

    // ✅ 재정렬 및 저장
    const batch = db.batch();
    let cursor = baseTime;

    for (const t of reorderList) {
      const duration = t.data.duration;
      const start = new Date(cursor.getTime());
      const end = new Date(start.getTime() + duration * 1000);

      const ref = tracksCol.doc(t.id);
      const data = {
        ...t.data,
        startAt: admin.firestore.Timestamp.fromDate(start),
        endAt: admin.firestore.Timestamp.fromDate(end),
      };

      delete data.__isNew;
      batch.set(ref, data); // 항상 set 사용 (중복 허용)
      cursor = end;
    }

    await batch.commit();

    // ✅ 세션 문서의 updatedAt 필드도 갱신
    await sessionRef.update({
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return res.status(200).json({
      success: true,
      message: "트랙 추가 및 재정렬 완료",
      data: newTrack,
    });
  } catch (err) {
    console.error("❌ 트랙 추가 실패:", err);
    return res.status(500).json({
      success: false,
      message: "트랙 추가 중 서버 오류가 발생했습니다.",
    });
  }
});
