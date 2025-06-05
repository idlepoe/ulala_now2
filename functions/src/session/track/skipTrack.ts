import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/v2/https";
import {verifyAuth} from "../../utils/auth";
import {db} from "../../firebase";

export const skipTrack = onRequest({
  cors: true, memory: "1GiB",
  region: "asia-northeast3", minInstances: 1,
}, async (req, res: any) => {
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
    const participantRef = sessionRef.collection("participants").doc(uid);

    // ✅ 사용자 활동 시간 갱신
    await participantRef.update({
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    const tracksCol = sessionRef.collection("tracks");
    const trackRef = tracksCol.doc(trackId);
    const trackSnap = await trackRef.get();

    if (!trackSnap.exists) {
      return res.status(200).json({
        success: false,
        message: "해당 트랙이 존재하지 않습니다.",
      });
    }

    const trackData = trackSnap.data();
    const now = new Date();

    const startAt = trackData?.startAt?.toDate?.();
    const endAt = trackData?.endAt?.toDate?.();
    const isCurrentlyPlaying =
      startAt && endAt && now >= startAt && now < endAt;

    // ✅ 트랙 삭제
    await trackRef.delete();

    // ✅ 이후 트랙 재정렬 (현재 재생 중 트랙일 경우)
    if (isCurrentlyPlaying && endAt) {
      const afterSnap = await tracksCol
        .where("startAt", ">=", admin.firestore.Timestamp.fromDate(endAt))
        .orderBy("startAt")
        .get();

      const batch = db.batch();
      let cursor = now;

      for (const doc of afterSnap.docs) {
        const t = doc.data();
        const duration = typeof t.duration === "number" ? t.duration : 0;
        const newStart = new Date(cursor.getTime());
        const newEnd = new Date(newStart.getTime() + duration * 1000);

        batch.update(doc.ref, {
          startAt: admin.firestore.Timestamp.fromDate(newStart),
          endAt: admin.firestore.Timestamp.fromDate(newEnd),
        });

        cursor = newEnd;
      }

      await batch.commit();
    }

    // ✅ 세션 문서의 updatedAt 필드도 갱신
    await sessionRef.update({
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return res.status(200).json({
      success: true,
      message: isCurrentlyPlaying
        ? "현재 재생 중인 트랙이 스킵되었으며 이후 트랙이 재정렬되었습니다."
        : "트랙이 삭제되었습니다.",
      data: {
        deletedTrackId: trackId,
      },
    });
  } catch (error) {
    console.error("❌ 트랙 스킵 실패:", error);
    return res.status(500).json({
      success: false,
      message: "서버 오류로 인해 트랙을 건너뛰는 데 실패했습니다.",
    });
  }
});
