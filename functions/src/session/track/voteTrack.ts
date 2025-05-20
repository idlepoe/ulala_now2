import {onRequest} from 'firebase-functions/v2/https';
import {verifyAuth} from "../../utils/auth";
import {db} from "../../firebase";
import {buildEventLog, getRandomMessage} from "../../utils/utils";

export const voteTrack = onRequest({cors: true}, async (req, res: any) => {
    if (req.method !== 'POST') {
        return res.status(405).json({
            success: false,
            message: 'Method Not Allowed',
        });
    }

    try {
        const decoded = await verifyAuth(req);
        const uid = decoded.uid;
        const {sessionId, trackId, vote} = req.body;

        if (!sessionId || !trackId || !['like', 'dislike'].includes(vote)) {
            return res.status(200).json({
                success: false,
                message: 'sessionId, trackId, vote(like/dislike)는 필수입니다.',
            });
        }

        const sessionRef = db.collection('sessions').doc(sessionId);
        const trackRef = sessionRef.collection('tracks').doc(trackId);

        const [sessionSnap, trackSnap] = await Promise.all([
            sessionRef.get(),
            trackRef.get(),
        ]);

        if (!sessionSnap.exists || !trackSnap.exists) {
            return res.status(200).json({
                success: false,
                message: '세션 또는 트랙이 존재하지 않습니다.',
            });
        }

        const userRef = db.collection('users').doc(uid);
        const userSnap = await userRef.get();

        if (!userSnap.exists) {
            return res.status(404).json({
                success: false,
                message: '사용자 정보를 찾을 수 없습니다.',
            });
        }

        const userData = userSnap.data();
        const nickname = userData?.nickname || '알 수 없음';

        const trackData: any = trackSnap.data();

        const votes = trackData.votes || {like: [], dislike: []};
        const isAlreadyVoted =
            (vote === 'like' && votes.like.includes(uid)) ||
            (vote === 'dislike' && votes.dislike.includes(uid));

        if (isAlreadyVoted) {
            return res.status(200).json({
                success: false,
                message: `이미 ${vote === 'like' ? '좋아요' : '싫어요'}를 투표하셨습니다.`,
            });
        }

        // 기존 반대 투표에서 제거
        votes.like = votes.like.filter((id: string) => id !== uid);
        votes.dislike = votes.dislike.filter((id: string) => id !== uid);

        // 새로운 투표 반영
        if (vote === 'like') {
            votes.like.push(uid);
        } else {
            votes.dislike.push(uid);
        }

        const updateData: any = {votes};

        const likeMessages = [
            '👍 {nickname}님이 "{name}"에 하트를 눌렀어요!',
            '🎶 "{name}" 완전 취향 저격! — {nickname}님',
            '💖 {nickname}님, "{name}"에 푹 빠졌어요.',
            '👏 "{name}"은(는) {nickname}님의 플레이리스트 각!',
            '🌈 {nickname}님이 "{name}"에 감동 받았대요!',
        ];

        const dislikeMessages = [
            '👎 {nickname}님은 "{name}"이 별로래요...',
            '😐 "{name}"은(는) {nickname}님의 취향이 아니었나 봐요.',
            '🙅‍♀️ {nickname}님이 "{name}"을(를) 넘기고 싶어해요.',
            '🫤 "{name}"... {nickname}님은 관심 없음 표시!',
            '💤 {nickname}님이 "{name}"에 졸고 있어요...',
        ];

        await trackRef.update(updateData);

        const messages = vote === 'like' ? likeMessages : dislikeMessages;
        const message = getRandomMessage(messages, nickname, trackData.title);
        await db.collection('logs').doc('sessionEvents').collection('items').add(
            buildEventLog({
                type: 'vote',
                subtype: vote, // 'like' or 'dislike'
                sessionId,
                uid,
                nickname,
                message,
                trackId: trackData.id,
                trackTitle: trackData.title,
            })
        );

        return res.status(200).json({
            success: true,
            message: '투표가 반영되었습니다.',
            data: {
                trackId,
                likeCount: votes.like.length,
                dislikeCount: votes.dislike.length,
            },
        });
    } catch (error) {
        console.error('❌ 트랙 투표 실패:', error);
        return res.status(500).json({
            success: false,
            message: '트랙 투표 중 서버 오류가 발생했습니다.',
        });
    }
});

