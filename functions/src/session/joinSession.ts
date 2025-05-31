import {onRequest} from "firebase-functions/v2/https";
import {verifyAuth} from "../utils/auth";
import {db} from "../firebase";
import * as admin from "firebase-admin";

export const joinSession = onRequest({
  cors: true, memory: "1GiB", // ✅ 또는 "1GB"
  region: "asia-northeast3",
}, async (req, res: any) => {
  if (req.method !== "POST") {
    return res.status(200).json({
      success: false,
      message: "허용되지 않은 요청 방식입니다.",
    });
  }

  try {
    const decoded = req.query.debug === "true"
      ? { uid: req.body.uid || "__debug_user__", name: req.body.nickname || "디버그유저", picture: req.body.avatarUrl || "" }
      : await verifyAuth(req);

    const uid = decoded.uid;

    const {sessionId, nickname, avatarUrl} = req.body;

    // 유효성 검사
    if (!sessionId || typeof sessionId !== "string") {
      return res.status(200).json({
        success: false,
        message: "sessionId는 필수입니다.",
      });
    }

    if (!nickname || typeof nickname !== "string") {
      return res.status(200).json({
        success: false,
        message: "닉네임(nickname)은 필수입니다.",
      });
    }

    const allSessionSnap = await db.collection("sessions").get();
    const batch = db.batch();

    for (const doc of allSessionSnap.docs) {
      const sid = doc.id;
      const isTarget = sid === sessionId;

      if (!isTarget) {
        // 다른 세션에 참여 중이라면 제거
        const participantRef = doc.ref.collection("participants").doc(uid);
        batch.delete(participantRef);
        // batch.update(doc.ref, {
        //   participantCount: admin.firestore.FieldValue.increment(-1),
        // });
      }
    }

    const targetSessionRef = db.collection("sessions").doc(sessionId);
    const targetSessionSnap = await targetSessionRef.get();

    if (!targetSessionSnap.exists) {
      return res.status(200).json({
        success: false,
        message: "해당 세션이 존재하지 않습니다.",
      });
    }

    const now = admin.firestore.Timestamp.now();

    // 현재 세션에 참여자로 추가
    const participantRef = targetSessionRef.collection("participants").doc(uid);
    batch.set(participantRef, {
      uid,
      nickname,
      avatarUrl,
      createdAt: now,
      updatedAt: now,
    });

    // batch.update(targetSessionRef, {
    //   participantCount: admin.firestore.FieldValue.increment(1),
    // });

    await batch.commit();

    return res.status(200).json({
      success: true,
      message: "세션에 성공적으로 참가했습니다.",
    });
  } catch (error) {
    console.error("❌ 세션 참가 실패:", error);
    return res.status(500).json({
      success: false,
      message: "세션 참가 중 오류가 발생했습니다.",
    });
  }
});
