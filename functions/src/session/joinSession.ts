import {onRequest} from "firebase-functions/v2/https";
import {verifyAuth} from "../utils/auth";
import {db} from "../firebase";
import * as admin from "firebase-admin";

export const joinSession = onRequest({cors: true}, async (req, res: any) => {
  if (req.method !== "POST") {
    return res.status(405).json({
      success: false,
      message: "Method Not Allowed",
    });
  }

  try {
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;
    const {sessionId} = req.body;

    if (!sessionId || typeof sessionId !== "string") {
      return res.status(400).json({
        success: false,
        message: "sessionId는 필수입니다.",
      });
    }

    const userRef = db.collection("users").doc(uid);
    const userSnap = await userRef.get();
    if (!userSnap.exists) {
      return res.status(404).json({
        success: false,
        message: "사용자 프로필이 존재하지 않습니다.",
      });
    }
    const user = userSnap.data()!;

    const allSessionSnap = await db.collection("sessions").get();
    const batch = db.batch();

    for (const doc of allSessionSnap.docs) {
      const sid = doc.id;
      const data = doc.data();
      const managers: string[] = data.managers || [];
      const isTarget = sid === sessionId;

      if (!isTarget) {
        // managers 에서 제거
        if (managers.includes(uid)) {
          const updatedManagers = managers.filter((m) => m !== uid);
          batch.update(doc.ref, {managers: updatedManagers});
        }
        // participants 서브컬렉션에서 제거
        const participantRef = doc.ref.collection("participants").doc(uid);
        batch.delete(participantRef);
        // participantCount 감소
        batch.update(doc.ref, {
          participantCount: admin.firestore.FieldValue.increment(-1),
        });
      }
    }

    const targetSessionRef = db.collection("sessions").doc(sessionId);
    const targetSessionSnap = await targetSessionRef.get();

    if (!targetSessionSnap.exists) {
      return res.status(404).json({
        success: false,
        message: "해당 세션이 존재하지 않습니다.",
      });
    }

    const sessionData = targetSessionSnap.data()!;

    // 참여자 추가
    const participantRef = targetSessionRef.collection("participants").doc(uid);
    batch.set(participantRef, {
      uid,
      nickname: user.nickname ?? "",
      avatarUrl: user.avatarUrl ?? "",
    });

    // managers가 비어있다면 현재 유저를 추가
    if (!sessionData.managers || sessionData.managers.length === 0) {
      batch.update(targetSessionRef, {
        managers: [uid],
      });
    }

    // participantCount 증가
    batch.update(targetSessionRef, {
      participantCount: admin.firestore.FieldValue.increment(1),
    });

    // 커밋
    await batch.commit();
    return res.status(200).json({
      success: true,
      message: "세션 참가 완료",
    });
  } catch (error) {
    console.error("❌ 세션 참가 실패:", error);
    return res.status(500).json({
      success: false,
      message: error instanceof Error ? error.message : "Unknown error",
    });
  }
});
