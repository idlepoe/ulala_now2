import 'package:flutter/material.dart';

class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('울랄라란?'),
      content: const Text(
        '울랄라는 함께 음악을 공유하고 감상하는 세션 기반 음악 앱입니다.\n\n'
            '- 누구나 세션을 만들고 초대할 수 있어요.\n'
            '- YouTube에서 좋아하는 음악을 검색해 트랙으로 추가하고,\n'
            '- 참가자들과 함께 플레이리스트를 만들 수 있어요.\n'
            '- 건너뛰기 기능, 즐겨찾기, 재생 이력 기능도 제공됩니다.\n\n'
            '친구들과 함께하는 실시간 음악 감상, 울랄라로 시작해보세요!',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
