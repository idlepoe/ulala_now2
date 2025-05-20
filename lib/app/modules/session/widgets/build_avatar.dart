import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget buildAvatar({
  required String url,
  required String nickname,
  double size = 24,
}) {
  final hasImage = url.isNotEmpty;

  return GFAvatar(
    size: size,
    backgroundImage: hasImage ? CachedNetworkImageProvider(url) : null,
    child: hasImage
        ? null
        : Text(
      nickname.isNotEmpty ? nickname[0] : '?',
      style: TextStyle(
        fontSize: size * 0.6,
        fontWeight: FontWeight.bold,
      ),
    ),
    shape: GFAvatarShape.circle,
  );
}
