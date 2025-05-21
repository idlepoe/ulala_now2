import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        overlayOpacity: 0.1,
        spacing: 10,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.playlist_add),
            backgroundColor: Colors.green,
            label: '트랙 추가',
            onTap: onAddTrack,
          ),
          SpeedDialChild(
            child: const Icon(Icons.history),
            backgroundColor: Colors.orange,
            label: '트랙 이력',
            onTap: onShowHistory,
          ),
          SpeedDialChild(
            child: const Icon(Icons.share),
            backgroundColor: Colors.indigo,
            label: '세션 공유',
            onTap: onShare,
          ),
        ],
      ),
    );
  }
}
