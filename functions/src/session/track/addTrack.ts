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
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;
    const {sessionId, track} = req.body;

    if (!sessionId || !track) {
      return res.status(200).json({
        success: false,
        message: "sessionId와 track 정보는 필수입니다.",
      });
    }

    const sessionRef = db.collection("sessions").doc(sessionId);
    const tracksCol = sessionRef.collection("tracks");

    // 현재 시간 기준
    const now = new Date();

    // 미래에 예약된 트랙들 가져오기
    const futureSnap = await tracksCol
      .where("startAt", ">", admin.firestore.Timestamp.fromDate(now))
      .orderBy("startAt", "asc")
      .get();

    // 마지막 트랙의 endAt을 기준으로 시작 시간 계산
    let baseTime = now;
    if (!futureSnap.empty) {
      const lastTrack = futureSnap.docs[futureSnap.docs.length - 1].data();
      const lastEnd = lastTrack.endAt.toDate();
      baseTime = lastEnd > baseTime ? lastEnd : baseTime;
    } else {
      const latestSnap = await tracksCol
        .orderBy("endAt", "desc")
        .limit(1)
        .get();

      if (!latestSnap.empty) {
        const last = latestSnap.docs[0].data();
        const lastEnd = last.endAt.toDate();
        baseTime = lastEnd > baseTime ? lastEnd : baseTime;
      }
    }

    const startAt = baseTime;
    const endAt = new Date(startAt.getTime() + track.duration * 1000);

    // 사용자 정보는 클라이언트에서 함께 전송한다고 가정
    const addedBy = {
      uid,
      nickname: track.addedBy?.nickname || "알 수 없음",
      avatarUrl: track.addedBy?.avatarUrl || "",
    };

    const trackToAdd = {
      ...track,
      startAt: admin.firestore.Timestamp.fromDate(startAt),
      endAt: admin.firestore.Timestamp.fromDate(endAt),
      addedBy,
      createdAt: admin.firestore.Timestamp.now(),
    };

    // 트랙 저장
    await tracksCol.doc(track.id).set(trackToAdd);

    // ⏰ 미래 트랙들 정렬 후 재계산
    const reordered = futureSnap.docs
      .map((doc) => ({id: doc.id, data: doc.data()}))
      .sort((a, b) =>
        a.data.createdAt.toDate().getTime() - b.data.createdAt.toDate().getTime(),
      );

    let currentStart = new Date(endAt.getTime());

    for (const doc of reordered) {
      const duration = doc.data.duration;
      const start = new Date(currentStart.getTime());
      const end = new Date(start.getTime() + duration * 1000);

      await tracksCol.doc(doc.id).update({
        startAt: admin.firestore.Timestamp.fromDate(start),
        endAt: admin.firestore.Timestamp.fromDate(end),
      });

      currentStart = end;
    }

    return res.status(200).json({
      success: true,
      message: "트랙 추가 완료",
      data: trackToAdd,
    });
  } catch (error) {
    console.error("❌ 트랙 추가 실패:", error);
    return res.status(500).json({
      success: false,
      message: "트랙 추가 중 서버 오류가 발생했습니다.",
    });
  }
});
