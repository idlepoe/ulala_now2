import {onRequest} from "firebase-functions/v2/https";
import {db} from "../firebase";

export const getSessionById = onRequest({cors: true}, async (req, res: any) => {
  if (req.method !== "GET") {
    return res.status(405).json({
      success: false,
      message: "Method Not Allowed",
    });
  }

  try {
    const sessionId = req.query.sessionId as string;
    if (!sessionId) {
      return res.status(400).json({
        success: false,
        message: "sessionId는 필수입니다.",
      });
    }

    const sessionRef = db.collection("sessions").doc(sessionId);
    const sessionSnap = await sessionRef.get();

    if (!sessionSnap.exists) {
      return res.status(404).json({
        success: false,
        message: "해당 세션이 존재하지 않습니다.",
      });
    }

    const sessionData = sessionSnap.data();

    // 🔽 participants 서브컬렉션 읽기
    const participantsSnap = await sessionRef.collection("participants").get();
    sessionData!.participants = participantsSnap.docs.map((doc) => doc.data());

    return res.status(200).json({
      success: true,
      message: "세션 상세 조회 성공",
      data: sessionData,
    });
  } catch (error) {
    console.error("❌ 세션 상세 조회 실패:", error);
    return res.status(500).json({success: false, message: "서버 오류"});
  }
});
