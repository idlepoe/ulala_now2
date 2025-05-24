import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/v2/https";
import {verifyAuth} from "../utils/auth";
import {db} from "../firebase";

export const createSession = onRequest({cors: true}, async (req, res: any) => {
  if (req.method !== "POST") {
    return res.status(200).json({
      success: false,
      message: "허용되지 않은 요청 방식입니다.",
    });
  }

  try {
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;

    const {name, nickname, avatarUrl, isPrivate, mode} = req.body;

    // 유효성 검사
    if (!name || typeof name !== "string") {
      return res.status(200).json({
        success: false,
        message: "세션 이름(name)은 필수입니다.",
      });
    }

    if (!nickname || typeof nickname !== "string") {
      return res.status(200).json({
        success: false,
        message: "닉네임(nickname)은 필수입니다.",
      });
    }

    const now = admin.firestore.Timestamp.now();
    const sessionRef = db.collection("sessions").doc();
    const sessionId = sessionRef.id;

    const sessionData = {
      id: sessionId,
      name,
      isPrivate,
      mode: mode ?? 'general', // ✅ null 또는 undefined이면 'general'
      createdBy: uid,
      createdAt: now,
      updatedAt: now,
      participantCount: 0,
    };

    // 세션 문서 저장
    await sessionRef.set(sessionData);

    // 참가자 서브컬렉션에 유저 정보 저장
    await sessionRef.collection("participants").doc(uid).set({
      uid,
      nickname,
      avatarUrl,
      createdAt: now,
      updatedAt: now,
    });

    return res.status(200).json({
      success: true,
      message: "세션이 성공적으로 생성되었습니다.",
      data: {
        sessionId,
        ...sessionData,
      },
    });
  } catch (error) {
    console.error("❌ 세션 생성 오류:", error);
    return res.status(500).json({
      success: false,
      message: "세션 생성 중 오류가 발생했습니다.",
    });
  }
});
