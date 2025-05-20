import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/v2/https";
import {verifyAuth} from "../../utils/auth";
import {db} from "../../firebase";

export const addTrack = onRequest({cors: true}, async (req, res: any) => {
  if (req.method !== "POST") {
    return res.status(405).json({
      success: false,
      message: "Method Not Allowed",
    });
  }

  try {
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;
    const {sessionId, track} = req.body;

    if (!sessionId || !track) {
      return res.status(400).json({
        success: false,
        message: "sessionId와 track 정보는 필수입니다.",
      });
    }

    const userRef = db.collection("users").doc(uid);
    const userSnap = await userRef.get();

    if (!userSnap.exists) {
      return res.status(400).json({
        success: false,
        message: "사용자 정보를 찾을 수 없습니다.",
      });
    }

    const userData: any = userSnap.data();
    const nickname = userData.nickname || "알 수 없음";

    const sessionRef = db.collection("sessions").doc(sessionId);
    const tracksCol = sessionRef.collection("tracks");

    // ✅ 스킵되지 않은 트랙 중 가장 마지막 트랙을 기준으로 시간 계산
    const latestNonSkippedSnap = await tracksCol
      .orderBy("endAt", "desc")
      .limit(1)
      .get();

    const now = new Date();
    let startAt = now;

    if (!latestNonSkippedSnap.empty) {
      const lastTrack = latestNonSkippedSnap.docs[0].data();
      const lastEnd = lastTrack.endAt.toDate();
      if (lastEnd > now) {
        startAt = lastEnd;
      }
    }

    const endAt = new Date(startAt.getTime() + track.duration * 1000);

    const trackToAdd = {
      ...track,
      startAt: admin.firestore.Timestamp.fromDate(startAt),
      endAt: admin.firestore.Timestamp.fromDate(endAt),
      addedBy: {
        uid: uid,
        nickname: nickname,
      },
      addedAt: admin.firestore.Timestamp.now(),
      votes: {
        like: [],
        dislike: [],
      },
    };

    const trackDocRef = tracksCol.doc(track.id);
    await trackDocRef.set(trackToAdd);

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

