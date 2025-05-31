import { onSchedule } from 'firebase-functions/v2/scheduler';

const getUrls = () => [
  {
    url: 'https://asia-northeast3-ulala-now2.cloudfunctions.net/getSessionList',
    method: 'GET',
  },
  {
    url: 'https://asia-northeast3-ulala-now2.cloudfunctions.net/getPlayedTracks?sessionId=oZj87fCifMMTt4Bnh19d&limit=1',
    method: 'GET',
  },
  {
    url: 'https://asia-northeast3-ulala-now2.cloudfunctions.net/getSessionById?sessionId=oZj87fCifMMTt4Bnh19d&debug=true',
    method: 'GET',
  },
  {
    url: 'https://asia-northeast3-ulala-now2.cloudfunctions.net/joinSession?debug=true',
    method: 'POST',
    body: {
      sessionId: 'oZj87fCifMMTt4Bnh19d',
      uid: 'debugUser01',
      nickname: '디버그유저',
      avatarUrl: '',
    },
  },
];

export const keepWarm = onSchedule('every 5 minutes', async () => {
  console.log('🔥 Running keepWarm pings...');

  const urls = getUrls();

  for (const { url, method, body } of urls) {
    try {
      const res = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
        ...(method === 'POST' && body ? { body: JSON.stringify(body) } : {}),
      });

      console.log(`✅ [${method}] ${url} → ${res.status}`);
    } catch (e) {
      console.error(`❌ keep-warm 실패 (${url}):`, e);
    }
  }

  console.log('✅ keepWarm completed.');
});
