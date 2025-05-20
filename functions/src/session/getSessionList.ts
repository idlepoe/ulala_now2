import {onRequest} from 'firebase-functions/v2/https';
import {verifyAuth} from "../utils/auth";
import {db} from "../firebase";

export const getSessionList = onRequest({cors: true}, async (req, res: any) => {
    if (req.method !== 'GET') {
        return res.status(405).json({success: false, message: 'Method Not Allowed'});
    }

    try {
        await verifyAuth(req);

        const snapshot = await db.collection('sessions')
            .orderBy('createdAt', 'desc')
            .limit(50)
            .get();

        const list = await Promise.all(snapshot.docs.map(async (doc) => {
            const data = doc.data();

            const participantsSnap = await doc.ref.collection('participants').get();
            const participants = participantsSnap.docs.map(d => d.data());

            return {
                ...data,
                participants,
            };
        }));

        return res.status(200).json({
            success: true,
            message: '세션 리스트 조회 완료',
            data: list,
        });
    } catch (error) {
        console.error('❌ 세션 리스트 조회 실패:', error);
        return res.status(401).json({
            success: false,
            message: error ?? 'Unauthorized',
        });
    }
});