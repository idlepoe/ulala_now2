import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/v2/https";
import {verifyAuth} from "../../utils/auth";
import {db} from "../../firebase";

export const skipTrack = onRequest({cors: true}, async (req, res: any) => {
  if (req.method !== "POST") {
    return res.status(200).json({
      success: false,
      message: "허용되지 않은 요청 방식입니다.",
    });
  }

  try {
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;
    const {sessionId, trackId} = req.body;

    if (!sessionId || !trackId) {
      return res.status(200).json({
        success: false,
        message: "sessionId와 trackId는 필수입니다.",
      });
    }

    const sessionRef = db.collection("sessions").doc(sessionId);

    // 유저 활동 시간 갱신 START
    const participantRef = sessionRef.collection("participants")
      .doc(uid);

    await participantRef.update({
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    // 유저 활동 시간 갱신 END

    const trackRef = sessionRef.collection("tracks").doc(trackId);

    const [sessionSnap, trackSnap] = await Promise.all([
      sessionRef.get(),
      trackRef.get(),
    ]);

    if (!sessionSnap.exists || !trackSnap.exists) {
      return res.status(200).json({
        success: false,
        message: "세션 또는 트랙이 존재하지 않습니다.",
      });
    }

    // 🗑️ 트랙 삭제
    await trackRef.delete();

    // 🔁 이후 트랙 재정렬
    const now = new Date();
    const remainingTracksSnap = await sessionRef.collection("tracks")
      .where("startAt", ">=", admin.firestore.Timestamp.fromDate(now))
      .orderBy("startAt")
      .get();

    const batch = db.batch();
    let newStart = now;

    for (const doc of remainingTracksSnap.docs) {
      const t = doc.data();
      const docRef = doc.ref;

      const newEnd = new Date(newStart.getTime() + t.duration * 1000);

      batch.update(docRef, {
        startAt: admin.firestore.Timestamp.fromDate(newStart),
        endAt: admin.firestore.Timestamp.fromDate(newEnd),
      });

      newStart = newEnd;
    }

    await batch.commit();

    return res.status(200).json({
      success: true,
      message: "트랙이 삭제되었으며, 이후 트랙들이 현재 시간 기준으로 재정렬되었습니다.",
      data: {
        trackId,
        deleted: true,
      },
    });
  } catch (error) {
    console.error("❌ 트랙 스킵 처리 실패:", error);
    return res.status(500).json({
      success: false,
      message: "서버 오류로 인해 트랙을 건너뛰는 데 실패했습니다.",
    });
  }
});

