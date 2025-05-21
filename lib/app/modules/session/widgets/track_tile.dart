import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ulala_now2/app/data/models/session_track.dart';

class TrackTile extends StatelessWidget {
  final SessionTrack track;
  final VoidCallback? onAdd;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final bool showFavorite;
  final bool isDisabled;
  final String? bottomText; // ✅ 재생 시간 표시용 추가

  const TrackTile({
    super.key,
    required this.track,
    this.onAdd,
    this.onFavorite,
    this.isFavorite = false,
    this.showFavorite = true,
    this.isDisabled = false,
    this.bottomText,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidth = Get.width / 5;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: track.thumbnail,
          width: imageWidth,
          height: 60,
          fit: BoxFit.cover,
          placeholder:
              (context, url) => SizedBox(
                width: imageWidth,
                height: 40,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          errorWidget:
              (context, url, error) => SizedBox(
                width: imageWidth,
                height: 40,
                child: const Center(child: Icon(Icons.broken_image)),
              ),
        ),
      ),
      title: Text(track.title, maxLines: 2, style: TextStyle(fontSize: 14)),
      subtitle:
          bottomText != null
              ? Text(
                bottomText!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )
              : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color:
                  isDisabled ? Colors.grey : (isFavorite ? Colors.red : null),
            ),
            onPressed: isDisabled ? null : onFavorite,
          ),
          IconButton(
            icon: Icon(Icons.playlist_add, color: isDisabled ? Colors.grey : null),
            onPressed: isDisabled ? null : onAdd,
          ),
        ],
      ),
    );
  }
}
