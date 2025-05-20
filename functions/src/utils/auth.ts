import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

export async function verifyAuth(req:any): Promise<admin.auth.DecodedIdToken> {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new functions.https.HttpsError('unauthenticated', 'Authorization header missing');
  }

  const idToken = authHeader.split('Bearer ')[1];

  try {
    const decoded = await admin.auth().verifyIdToken(idToken);
    return decoded;
  } catch (error) {
    throw new functions.https.HttpsError('unauthenticated', 'Invalid Firebase ID token');
  }
}
