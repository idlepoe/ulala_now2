import * as admin from 'firebase-admin';
import {onRequest} from 'firebase-functions/v2/https';
import {verifyAuth} from "../utils/auth";
import {db} from "../firebase";
import {buildEventLog, getRandomMessage} from "../utils/utils";

export const createSession = onRequest({cors: true}, async (req, res: any) => {
    if (req.method !== 'POST') {
        return res.status(405).json({
            success: false,
            message: 'Method Not Allowed',
        });
    }

    try {
        const decoded = await verifyAuth(req);
        const uid = decoded.uid;
        const {name} = req.body;

        if (!name || typeof name !== 'string') {
            return res.status(400).json({
                success: false,
                message: '세션 이름(name)은 필수입니다.',
            });
        }

        const now = admin.firestore.Timestamp.now();
        const sessionRef = db.collection('sessions').doc();
        const sessionId = sessionRef.id; // ✅ 이 줄 추가

        const userSnap = await db.collection('users').doc(uid).get();
        if (!userSnap.exists) {
            return res.status(404).json({
                success: false,
                message: '사용자 프로필이 존재하지 않습니다.',
            });
        }
        const user = userSnap.data()!;

        const sessionData = {
            id: sessionRef.id,
            name,
            createdBy: uid,
            managers: [uid],
            isActive: true,
            createdAt: now,
            participantCount: 1
        };

        await sessionRef.set(sessionData);

        await sessionRef.collection('participants').doc(uid).set({
            uid,
            nickname: user.nickname ?? '',
            avatarUrl: user.avatarUrl ?? '',
        });

        const messages = [
            '🙋 {nickname}님이 새로운 세션 "{name}"을 열었어요!',
            '🎉 {nickname}의 파티가 시작됐습니다: "{name}"',
            '🚪 "{name}" 세션이 개장되었습니다. 주최: {nickname}님!',
            '🌟 {nickname}님, "{name}"이라는 세션으로 음악 세계를 열었어요!',
        ];

        const message = getRandomMessage(messages, user.nickname, name);

        await db.collection('logs').doc('sessionEvents').collection('items').add(
            buildEventLog({
                type: 'create',
                sessionId,
                uid,
                nickname: user.nickname,
                message,
            })
        );

        return res.status(200).json({
            success: true,
            message: '세션 생성 완료',
            data: {
                sessionId,
                ...sessionData,
            }
        });
    } catch (error) {
        console.error('❌ 세션 생성 실패:', error);
        return res.status(401).json({
            success: false,
            message: error ?? 'Unauthorized',
        });
    }
});