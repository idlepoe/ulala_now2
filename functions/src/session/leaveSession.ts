import {onRequest} from 'firebase-functions/v2/https';
import {verifyAuth} from "../utils/auth";
import {db} from "../firebase";
import * as admin from 'firebase-admin';
import {buildEventLog, getRandomMessage} from "../utils/utils";

export const leaveSession = onRequest({cors: true}, async (req, res: any) => {
    if (req.method !== 'POST') {
        return res.status(405).json({success: false, message: 'Method Not Allowed'});
    }

    try {
        const decoded = await verifyAuth(req);
        const uid = decoded.uid;
        const {sessionId} = req.body;

        if (!sessionId) {
            return res.status(400).json({success: false, message: 'sessionId는 필수입니다.'});
        }

        const sessionRef = db.collection('sessions').doc(sessionId);
        const sessionSnap = await sessionRef.get();

        if (!sessionSnap.exists) {
            return res.status(404).json({success: false, message: '세션이 존재하지 않습니다.'});
        }

        const participantRef = sessionRef.collection('participants').doc(uid);
        const participantSnap = await participantRef.get();

        if (participantSnap.exists) {
            const participantData = participantSnap.data();
            const nickname = participantData?.nickname || '알 수 없음';

            // 🔹 참가자 삭제
            await participantRef.delete();

            const messages = [
                '💨 {nickname}님이 세션을 떠났어요. 다음에 또 만나요!',
                '👋 {nickname}님, 안녕히 가세요~',
                '😢 {nickname}님이 이별을 고했습니다...',
                '🏃‍♀️ {nickname}님이 빠르게 퇴장하셨어요.',
            ];

            const message = getRandomMessage(messages, nickname, "");

            await db.collection('logs').doc('sessionEvents').collection('items').add(
                buildEventLog({
                    type: 'leave',
                    sessionId,
                    uid,
                    nickname,
                    message,
                })
            );
        }

        // 🔸 managers 배열에서 제거
        await sessionRef.update({
            managers: admin.firestore.FieldValue.arrayRemove(uid),
        });

        // 참가자 문서가 있으면 삭제
        if (participantSnap.exists) {
            await participantRef.delete();

            // ✅ participantCount 감소
            await sessionRef.update({
                participantCount: admin.firestore.FieldValue.increment(-1),
            });
        }

        return res.status(200).json({
            success: true,
            message: '세션 나가기 완료',
        });
    } catch (error) {
        console.error('❌ 세션 나가기 실패:', error);
        return res.status(401).json({
            success: false,
            message: error instanceof Error ? error.message : 'Unauthorized',
        });
    }
});
