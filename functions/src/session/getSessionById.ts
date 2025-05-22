import {onRequest} from "firebase-functions/v2/https";
import {db} from "../firebase";
import * as admin from "firebase-admin";
import {verifyAuth} from "../utils/auth";

export const getSessionById = onRequest({cors: true}, async (req, res: any) => {
  if (req.method !== "GET") {
    return res.status(405).json({
      success: false,
      message: "Method Not Allowed",
    });
  }

  try {
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;

    const sessionId = req.query.sessionId as string;
    if (!sessionId) {
      return res.status(400).json({
        success: false,
        message: "sessionId는 필수입니다.",
      });
    }

    const sessionRef = db.collection("sessions").doc(sessionId);

    // 유저 활동 시간 갱신 START
    const participantRef = sessionRef.collection("participants").doc(uid);

    const participantSnap = await participantRef.get();

    if (participantSnap.exists) {
      await participantRef.update({
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      // 문서가 없는 경우, createdAt과 함께 새로 생성
      await participantRef.set({
        uid: uid,
        nickname: decoded.name || "익명" + Math.random().toString(36).substr(2, 8),         // 예: decoded에 사용자 이름이 있을 경우
        avatarUrl: decoded.picture || "",      // 예: decoded에 프로필 이미지가 있을 경우
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      }, {merge: true}); // 다른 필드가 있다면 보존
    }
    // 유저 활동 시간 갱신 END


    const sessionSnap = await sessionRef.get();

    if (!sessionSnap.exists) {
      return res.status(404).json({
        success: false,
        message: "해당 세션이 존재하지 않습니다.",
      });
    }

    const now = new Date();
    const twelveHoursAgo = new Date(now.getTime() - 12 * 60 * 60 * 1000);

    // 세션 정보 불러오기
    const sessionData: any = sessionSnap.data();

    // 🔽 최근 12시간 내 활동한 참여자만 가져오기
    const participantsSnap = await sessionRef
      .collection("participants")
      .where("updatedAt", ">=", twelveHoursAgo)
      .orderBy("updatedAt", "desc")
      .get();

    sessionData.participants = participantsSnap.docs.map((doc) => doc.data());

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
