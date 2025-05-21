import {onRequest} from "firebase-functions/v2/https";
import {verifyAuth} from "../utils/auth";
import {db} from "../firebase";

export const getSessionList = onRequest({cors: true}, async (req, res: any) => {
  if (req.method !== "GET") {
    return res.status(405).json({
      success: false,
      message: "Method Not Allowed",
    });
  }

  try {
    await verifyAuth(req);

    const threeDaysAgo = new Date(Date.now() - 3 * 24 * 60 * 60 * 1000);

    const snapshot = await db.collection("sessions")
      .where("updatedAt", ">=", threeDaysAgo) // ✅ 3일 이내만
      .orderBy("updatedAt", "desc")
      .limit(50)
      .get();

    const now = new Date();
    const twelveHoursAgo = new Date(now.getTime() - 12 * 60 * 60 * 1000);

    const list = await Promise.all(snapshot.docs.map(async (doc) => {
      const data = doc.data();

      const participantsSnap = await doc.ref.collection("participants").get();
      const allParticipants = participantsSnap.docs.map((d) => d.data());

      const activeParticipants = allParticipants.filter((p) => {
        const raw = p.updatedAt;
        if (!raw) return false;

        const updatedAt: Date =
          typeof raw.toDate === 'function' ? raw.toDate() : new Date(raw);

        return updatedAt >= twelveHoursAgo;
      });

      return {
        ...data,
        participantCount: activeParticipants.length, // ✅ 여기 핵심
      };
    }));

    return res.status(200).json({
      success: true,
      message: "세션 리스트 조회 완료",
      data: list,
    });
  } catch (error) {
    console.error("❌ 세션 리스트 조회 실패:", error);
    return res.status(401).json({
      success: false,
      message: error ?? "Unauthorized",
    });
  }
});
