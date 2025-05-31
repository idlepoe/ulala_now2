import {onRequest} from "firebase-functions/v2/https";
import {db} from "../firebase";
import * as admin from "firebase-admin";
import {verifyAuth} from "../utils/auth";

export const getSessionById = onRequest({
  cors: true,
  memory: "1GiB",
  region: "asia-northeast3",
}, async (req, res: any) => {
  if (req.method !== "GET") {
    return res.status(405).json({ success: false, message: "Method Not Allowed" });
  }

  try {
    console.time("전체 실행");

    const isWarmup = req.query.debug === "true";
    const sessionId = req.query.sessionId as string;
    const uid = isWarmup
      ? (req.query.uid as string ?? "warmup-dummy-uid") // 🔸 fallback uid
      : (await verifyAuth(req)).uid;

    if (!sessionId) {
      return res.status(400).json({ success: false, message: "sessionId는 필수입니다." });
    }

    const sessionRef = db.collection("sessions").doc(sessionId);

    // ✅ 유저 활동 기록은 warmup일 때는 생략 가능
    if (!isWarmup) {
      console.time("유저 활동 시간 갱신");
      const participantRef = sessionRef.collection("participants").doc(uid);
      const participantSnap = await participantRef.get();
      if (participantSnap.exists) {
        await participantRef.update({ updatedAt: admin.firestore.FieldValue.serverTimestamp() });
      } else {
        await participantRef.set({
          uid,
          nickname: "익명_" + Math.random().toString(36).substr(2, 5),
          avatarUrl: "",
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });
      }
      console.timeEnd("유저 활동 시간 갱신");
    }

    const sessionSnap = await sessionRef.get();
    if (!sessionSnap.exists) {
      return res.status(404).json({ success: false, message: "세션이 존재하지 않습니다." });
    }

    const now = new Date();
    const twelveHoursAgo = new Date(now.getTime() - 12 * 60 * 60 * 1000);
    const sessionData: any = sessionSnap.data();

    console.time("최근 12시간 내 활동한 참여자만 가져오기");
    const participantsSnap = await sessionRef
      .collection("participants")
      .where("updatedAt", ">=", twelveHoursAgo)
      .orderBy("updatedAt", "desc")
      .get();
    sessionData.participants = participantsSnap.docs.map((doc) => doc.data());
    console.timeEnd("최근 12시간 내 활동한 참여자만 가져오기");

    console.timeEnd("전체 실행");
    return res.status(200).json({
      success: true,
      message: "세션 상세 조회 성공",
      data: sessionData,
      _warmup: isWarmup,
    });

  } catch (error) {
    console.error("❌ 세션 상세 조회 실패:", error);
    return res.status(500).json({ success: false, message: "서버 오류" });
  }
});
