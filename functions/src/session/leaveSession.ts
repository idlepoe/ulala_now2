import {onRequest} from "firebase-functions/v2/https";
import {db} from "../firebase";

export const leaveSession = onRequest({
  cors: true, memory: "1GiB", // ✅ 또는 "1GB"
  region: "asia-northeast3", minInstances: 1,
}, async (req, res: any) => {
  if (req.method !== "POST") {
    return res.status(200).json({
      success: false,
      message: "허용되지 않은 요청 방식입니다.",
    });
  }

  try {
    const {sessionId} = req.body;

    if (!sessionId || typeof sessionId !== "string") {
      return res.status(200).json({
        success: false,
        message: "sessionId는 필수입니다.",
      });
    }

    const sessionRef = db.collection("sessions").doc(sessionId);
    const sessionSnap = await sessionRef.get();

    if (!sessionSnap.exists) {
      return res.status(200).json({
        success: false,
        message: "세션이 존재하지 않습니다.",
      });
    }

    return res.status(200).json({
      success: true,
      message: "세션에서 성공적으로 나갔습니다.",
    });
  } catch (error) {
    console.error("❌ 세션 나가기 실패:", error);
    return res.status(500).json({
      success: false,
      message: "세션 나가기 중 오류가 발생했습니다.",
    });
  }
});
