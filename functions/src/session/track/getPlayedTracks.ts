import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const getPlayedTracks = functions.https.onRequest(async (req, res: any) => {
  try {
    const sessionId = req.query.sessionId as string;
    const limit = parseInt(req.query.limit as string) || 20;
    const lastEndAt = req.query.lastEndAt;

    let lastEndAtDate: Date | null = null;

    if (typeof lastEndAt === "string") {
      lastEndAtDate = new Date(lastEndAt);
      if (isNaN(lastEndAtDate.getTime())) {
        return res.status(200).json({
          success: false,
          message: "잘못된 lastEndAt 값입니다.",
        });
      }
    }

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

    if (lastEndAtDate) {
      query = query.startAfter(lastEndAtDate);
    }

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
