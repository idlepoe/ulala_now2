import 'package:flutter/material.dart';

class InfoButtonYoutubeQuota extends StatelessWidget {
  const InfoButtonYoutubeQuota({super.key});

  @override
  Widget build(BuildContext context) {
    String youtubeQuotaNotice = '''
현재 앱은 YouTube API의 제한된 할당량 내에서 운영되고 있어, 사용자가 자유롭게 무제한 검색을 하기는 어렵습니다.

🔒 검색 제한 안내
- YouTube 영상 검색은 일정 시간마다 1회만 가능합니다.
- 이는 Google API의 무료 할당량 정책에 따라 적용됩니다.

📦 캐시 정보
- 검색된 트랙 정보는 최대 1주일 동안 캐시에 저장되어 다시 검색하지 않아도 빠르게 사용할 수 있습니다.

⭐ 앱 사용 팁
- 자주 사용하는 트랙은 '즐겨찾기' 기능으로 등록해두세요.
- 이전에 재생한 곡은 '재생된 트랙 목록'에서 쉽게 다시 확인하고 추가할 수 있습니다.

효율적인 트랙 검색과 재사용을 위해 위 기능들을 적극 활용해 주세요!
''';

    return IconButton(
      icon: const Icon(Icons.info_outline, color: Colors.grey),
      tooltip: "YouTube 검색 API 할당량 안내",
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("YouTube API 할당량 안내"),
                content: SingleChildScrollView(
                  child: Text(
                    youtubeQuotaNotice,
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text("확인"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
        );
      },
    );
  }
}
