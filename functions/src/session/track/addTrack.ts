import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/v2/https";
import {verifyAuth} from "../../utils/auth";
import {db} from "../../firebase";

export const addTrack = onRequest({cors: true}, async (req, res: any) => {
  if (req.method !== "POST") {
    return res.status(200).json({success: false, message: "허용되지 않은 요청 방식입니다."});
  }

  try {
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;
    const {sessionId, track} = req.body;

    if (!sessionId || !track) {
      return res.status(200).json({
        success: false,
        message: "sessionId와 track 정보는 필수입니다.",
      });
    }

    const sessionRef = db.collection("sessions").doc(sessionId);

    // 유저 활동 시간 갱신 START
    const participantRef = sessionRef.collection("participants")
      .doc(uid);

    await participantRef.update({
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    // 유저 활동 시간 갱신 END

    const tracksCol = sessionRef.collection("tracks");
    const now = new Date();

    // ✅ 현재 재생 중인 트랙 조회
    const currentSnap = await tracksCol
      .where("startAt", "<=", admin.firestore.Timestamp.fromDate(now))
      .where("endAt", ">", admin.firestore.Timestamp.fromDate(now))
      .limit(1)
      .get();

    let currentTrack: any = null;
    let baseTime = now;

    if (!currentSnap.empty) {
      const doc = currentSnap.docs[0];
      currentTrack = {id: doc.id, data: doc.data()};
      baseTime = currentTrack.data.endAt.toDate(); // 기준: 현재 재생 중 끝나는 시간
    }

    // ✅ baseTime 이후의 트랙 가져오기
    const afterSnap = await tracksCol
      .where("startAt", ">=", admin.firestore.Timestamp.fromDate(baseTime))
      .get();

    const futureTracks = afterSnap.docs
      .filter(doc => !currentTrack || doc.id !== currentTrack.id) // 현재 트랙은 제외
      .map(doc => ({id: doc.id, data: doc.data()}));

    // ✅ 클라이언트에서 전송한 새 트랙
    const addedBy = {
      uid,
      nickname: track.addedBy?.nickname ?? "알 수 없음",
      avatarUrl: track.addedBy?.avatarUrl ?? "",
    };

    const newTrack = {
      ...track,
      addedBy,
      createdAt: admin.firestore.Timestamp.now(),
      __isNew: true,
    };

    const reorderList = [...futureTracks, {id: track.id, data: newTrack}]
      .sort((a, b) =>
        a.data.createdAt.toDate().getTime() - b.data.createdAt.toDate().getTime(),
      );

    // ✅ 재정렬 후 startAt, endAt 재계산
    const batch = db.batch();
    let cursor = baseTime;

    for (const t of reorderList) {
      const duration = t.data.duration;
      const start = new Date(cursor.getTime());
      const end = new Date(start.getTime() + duration * 1000);

      const ref = tracksCol.doc(t.id);
      const data = {
        ...t.data,
        startAt: admin.firestore.Timestamp.fromDate(start),
        endAt: admin.firestore.Timestamp.fromDate(end),
      };

      if (t.data.__isNew) {
        batch.set(ref, data);
      } else {
        batch.update(ref, data);
      }

      cursor = end;
    }

    await batch.commit();

    return res.status(200).json({
      success: true,
      message: "트랙 추가 및 재정렬 완료",
      data: newTrack,
    });
  } catch (err) {
    console.error("❌ 트랙 추가 실패:", err);
    return res.status(500).json({
      success: false,
      message: "트랙 추가 중 서버 오류가 발생했습니다.",
    });
  }
});
