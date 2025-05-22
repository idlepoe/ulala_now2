# 🎵 울랄라 (Ulala)

> 지금 이 순간, 내가 듣는 노래를 공유해보세요

**Ulala**는 친구들과 함께 음악을 공유하고 동시에 감상할 수 있는  
**실시간 음악 세션 기반 소셜 플랫폼**입니다.  
Flutter + Firebase로 제작되었으며, 유튜브 트랙 추가, 실시간 재생 동기화, 채팅 기능 등을 제공합니다.

---

## 🌐 공식 웹사이트 및 앱

- 🔗 웹버전: [https://ulala-now2.web.app](https://ulala-now2.web.app)
- 📱 Google Play: [울랄라 앱 설치하기](https://play.google.com/store/apps/details?id=com.jylee.ulala_now2)

---

## 🚀 주요 기능

- 🎶 **세션 기반 음악 공유**: 실시간으로 음악을 함께 들으며 감상
- 🔍 **YouTube 검색 및 트랙 추가**: 원하는 곡을 손쉽게 추가
- 💬 **세션별 실시간 채팅**: 음악과 함께 소통
- ⭐ **즐겨찾기 관리**: 자주 듣는 곡을 따로 저장

---

## 🛠️ 기술 스택

- **Flutter** (Dart)
- **Firebase**
    - Authentication
    - Firestore
    - Storage
    - 🔧 Cloud Functions
    - 🏠 Hosting
- [GetX](https://pub.dev/packages/get) – 경량 상태관리 및 라우팅
- [Shorebird](https://pub.dev/packages/shorebird_code_push) – OTA(Over-the-air) 코드 푸시

---

## 🧑‍💻 시작하기

```bash
git clone https://github.com/yourname/ulala.git
cd ulala
flutter pub get
flutter run
