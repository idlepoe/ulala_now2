import 'package:flutter/material.dart';

import 'info_button_youtube_quota.dart';

class YoutubeSearchInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String keyword) onSearch;
  final bool enabled;
  final String? cooldownMessage; // ✅ 안내 문구 (쿨타임 남은 시간 등)

  const YoutubeSearchInput({
    super.key,
    required this.controller,
    required this.onSearch,
    this.enabled = true,
    this.cooldownMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: "노래 제목 또는 아티스트 입력",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                final keyword = controller.text.trim();
                if (keyword.isNotEmpty && enabled) {
                  onSearch(keyword);
                }
              },
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty && enabled) {
              onSearch(value.trim());
            }
          },
        ),

        // 🔴 쿨다운 안내 메시지를 위에 겹쳐서 표시
        if (!enabled && cooldownMessage != null)
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cooldownMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  InfoButtonYoutubeQuota(),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
