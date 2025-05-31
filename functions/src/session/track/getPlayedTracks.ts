import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/https";

export const getPlayedTracks = onRequest({
  cors: true, memory: "1GiB", // ✅ 또는 "1GB"
  region: "asia-northeast3",
}, async (req, res: any) => {
  try {
    const sessionId = req.query.sessionId as string;
    const limit = parseInt(req.query.limit as string) || 20;

    if (!sessionId) {
      return res.status(200).json({
        success: false,
        message: "sessionId 파라미터가 필요합니다.",
      });
    }


    const now = new Date();

    let query = admin
      .firestore()
      .collection("sessions")
      .doc(sessionId)
      .collection("tracks")
      .where("endAt", "<=", now)
      .orderBy("endAt", "desc")
      .limit(limit);

    const snapshot = await query.get();

    const tracks = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    return res.status(200).json({
      success: true,
      data: tracks,
    });
  } catch (error) {
    console.error("getPlayedTracks error:", error);
    return res.status(500).json({
      success: false,
      message: "트랙 목록 조회에 실패했습니다.",
    });
  }
});
