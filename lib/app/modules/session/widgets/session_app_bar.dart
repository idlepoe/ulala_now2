import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SessionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSync;
  final VoidCallback onAddTrack;
  final VoidCallback onShowHistory;
  final VoidCallback onShare;

  const SessionAppBar({
    super.key,
    required this.title,
    required this.onSync,
    required this.onAddTrack,
    required this.onShowHistory,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _openMenu(context),
      ),
      actions: [
        TextButton.icon(
          onPressed: onSync,
          icon: const Icon(Icons.refresh),
          label: const Text("싱크"),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: "트랙 추가",
          onPressed: onAddTrack,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('재생된 트랙 목록'),
              onTap: () {
                Navigator.pop(context); // 먼저 BottomSheet 닫고
                onShowHistory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('세션 공유하기'),
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
