import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget buildAvatar({
  required String url,
  required String nickname,
  double size = 24,
}) {
  final hasImage = url.isNotEmpty;
  final fallbackText = nickname.isNotEmpty ? nickname[0] : '?';

  return CircleAvatar(
    radius: size / 2,
    backgroundColor: const Color(0xFF4285F4), // ✅ 고정된 배경색 (예: Google Blue)
    backgroundImage: hasImage ? CachedNetworkImageProvider(url) : null,
    child:
        hasImage
            ? null
            : Text(
              fallbackText,
              style: TextStyle(
                fontSize: size * 0.45, // ✅ 크기에 맞는 글자 크기
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
  );
}
