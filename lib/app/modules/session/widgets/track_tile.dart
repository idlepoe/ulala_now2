import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:ulala_now2/app/data/models/session_track.dart';

class TrackTile extends StatelessWidget {
  final SessionTrack track;
  final VoidCallback? onAdd;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final bool showFavorite;
  final bool isDisabled;

  const TrackTile({
    super.key,
    required this.track,
    this.onAdd,
    this.onFavorite,
    this.isFavorite = false,
    this.showFavorite = true,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GFListTile(
      avatar: CachedNetworkImage(
        imageUrl: track.thumbnail,
        width: 160,
        height: 60,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => const SizedBox(
              width: 60,
              height: 40,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        errorWidget:
            (context, url, error) => const SizedBox(
              width: 60,
              height: 40,
              child: Center(child: Icon(Icons.broken_image)),
            ),
      ),
      title: Text(track.title, maxLines: 1),
      subTitle: Text(
        track.description,
        maxLines: 2,
        style: TextStyle(color: Colors.grey),
      ),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFIconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color:
                  isDisabled ? Colors.grey : (isFavorite ? Colors.red : null),
            ),
            onPressed: isDisabled ? null : onFavorite,
            type: GFButtonType.transparent,
          ),
          GFIconButton(
            icon: Icon(Icons.add, color: isDisabled ? Colors.grey : null),
            onPressed: isDisabled ? null : onAdd,
            type: GFButtonType.transparent,
          ),
        ],
      ),
    );
  }
}
