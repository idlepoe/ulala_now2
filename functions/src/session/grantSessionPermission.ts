import {onRequest} from 'firebase-functions/v2/https';
import {verifyAuth} from "../utils/auth";
import {db} from "../firebase";

export const grantSessionPermission = onRequest({ cors: true }, async (req, res: any) => {
    if (req.method !== 'POST') {
        return res.status(405).json({ success: false, message: 'Method Not Allowed' });
    }

    try {
        const decoded = await verifyAuth(req);
        const uid = decoded.uid;
        const { sessionId, targetUid } = req.body;

        if (!sessionId || !targetUid) {
            return res.status(400).json({ success: false, message: 'sessionId와 targetUid는 필수입니다.' });
        }

        const sessionRef = db.collection('sessions').doc(sessionId);
        const sessionSnap = await sessionRef.get();
        if (!sessionSnap.exists) {
            return res.status(404).json({ success: false, message: '해당 세션이 존재하지 않습니다.' });
        }

        const sessionData = sessionSnap.data();
        const managers = sessionData?.managers ?? [];

        if (!managers.includes(uid)) {
            return res.status(403).json({ success: false, message: '권한이 없습니다.' });
        }

        if (!managers.includes(targetUid)) {
            managers.push(targetUid);
        }

        await sessionRef.update({ managers });

        return res.status(200).json({
            success: true,
            message: '권한 부여 완료',
        });
    } catch (error) {
        console.error('❌ 권한 부여 실패:', error);
        return res.status(500).json({ success: false, message: '서버 오류' });
    }
});