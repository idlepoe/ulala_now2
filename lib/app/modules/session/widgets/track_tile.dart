import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ulala_now2/app/data/models/session_track.dart';

import '../controllers/session_controller.dart';

class TrackTile extends StatelessWidget {
  final SessionTrack track;
  final VoidCallback? onAdd;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final bool showFavorite;
  final bool isDisabled;
  final Widget? bottomWidget; // 기존 bottomText 제거 후 추가

  const TrackTile({
    super.key,
    required this.track,
    this.onAdd,
    this.onFavorite,
    this.isFavorite = false,
    this.showFavorite = true,
    this.isDisabled = false,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidth = kIsWeb ? 95.0 : (Get.width / 5);
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
      subtitle: bottomWidget,
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
          GetBuilder<SessionController>(
            builder: (controller) {
              final canControl = controller.canControlTrack();

              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.playlist_add),
                    tooltip:
                        canControl ? 'add_track'.tr : 'dj_only_track_add'.tr,
                    onPressed: (!canControl || isDisabled) ? null : onAdd,
                    color: canControl ? null : Colors.grey,
                  ),
                  if (!canControl)
                    Positioned(
                      bottom: 4,
                      child: Text(
                        'dj_only'.tr,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
