import {setGlobalOptions} from "firebase-functions";
import {initializeApp} from "firebase-admin/app";

initializeApp();
setGlobalOptions({region: "asia-northeast3"});

// 세션
export {createSession} from "./session/createSession";
export {getSessionList} from "./session/getSessionList";
export {leaveSession} from "./session/leaveSession";
export {joinSession} from "./session/joinSession";
export {getSessionById} from "./session/getSessionById";

// 트랙
export {addTrack} from "./session/track/addTrack";
export {skipTrack} from "./session/track/skipTrack";
export {voteTrack} from "./session/track/voteTrack";

export {getPlayedTracks} from "./session/track/getPlayedTracks";
