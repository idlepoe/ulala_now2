# 🎵 울랄라 (Ulala)

> 지금 이 순간, 내가 듣는 노래를 공유해보세요

Ulala는 친구들과 함께 음악을 공유하고 동시에 감상할 수 있는 실시간 세션 기반 음악 소셜 플랫폼입니다.  
Flutter + Firebase를 기반으로 제작되었으며, 유튜브 트랙을 세션에 추가하고, 실시간 투표 및 채팅 기능도 지원합니다.

---

## 🚀 주요 기능

- 🎶 실시간 음악 세션 생성 및 참여
- 🔍 유튜브 기반 음악 검색 및 재생
- 🗳️ 트랙 투표 및 스킵
- 💬 세션별 실시간 채팅
- ⭐ 즐겨찾기 트랙 관리

---

## 🧑‍💻 시작하기

```bash
git clone https://github.com/yourname/ulala.git
cd ulala
flutter pub get
flutter run


_flutter pub run flutter_launcher_icons
flutter pub run build_runner build --delete-conflicting-outputs
gsutil cors set cors.json gs://ulala-now2.firebasestorage.app
.\gradlew signingReport


flutter clean
flutter pub get
flutter build web --release
firebase deploy --only hosting


flutter build appbundle --release


get create page session_create

shorebird release android


flutter pub get
shorebird patch --platforms=android --release-version=1.0.0+1
