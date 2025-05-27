import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

class SessionFloatingMenu extends StatelessWidget {
  final VoidCallback onAddTrack;
  final VoidCallback onShowHistory;
  final VoidCallback onShare;

  const SessionFloatingMenu({
    super.key,
    required this.onAddTrack,
    required this.onShowHistory,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final iconColor = isDark ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        overlayOpacity: 0.1,
        spacing: 10,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: Icon(Icons.playlist_add, color: iconColor),
            backgroundColor: Theme.of(context).colorScheme.surface,
            label: 'add_track'.tr,
            labelStyle: TextStyle(color: labelColor),
            onTap: onAddTrack,
          ),
          SpeedDialChild(
            child: Icon(Icons.history, color: iconColor),
            backgroundColor: Theme.of(context).colorScheme.surface,
            label: 'track_history'.tr,
            labelStyle: TextStyle(color: labelColor),
            onTap: onShowHistory,
          ),
          SpeedDialChild(
            child: Icon(Icons.share, color: iconColor),
            backgroundColor: Theme.of(context).colorScheme.surface,
            label: 'share_session'.tr,
            labelStyle: TextStyle(color: labelColor),
            onTap: onShare,
          ),
        ],
      ),
    );
  }
}
