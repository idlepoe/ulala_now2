class ApiConstants {
  static const baseUrl = "https://asia-northeast3-ulala-now2.cloudfunctions.net";

  // ✅ 세션 관련
  static const String createSession = "/createSession";
  static const String getSessionList = "/getSessionList";
  static const String joinSession = "/joinSession";
  static const String leaveSession = "/leaveSession";
  static const String getSessionById = "/getSessionById";

  // ✅ 트랙 관련
  static const String addTrack = "/addTrack";
  static const String skipTrack = "/skipTrack";
  static const String voteTrack = "/voteTrack";
  static const String getPlayedTracks = "/getPlayedTracks";


}