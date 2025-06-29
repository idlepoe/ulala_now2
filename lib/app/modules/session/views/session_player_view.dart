import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';
import 'package:ulala_now2/app/modules/session/widgets/upcoming_trak_list.dart';

class SessionPlayerView extends GetView<SessionController> {
  const SessionPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // 앞으로 재생될 트랙 리스트
            SliverFillRemaining(child: UpcomingTrackList()),
          ],
        ),
      ),
    );
  }
}

class PlayerHeader extends StatelessWidget {
  final Widget Function() buildPlayer;
  final Widget? currentTrack;
  final double shrinkOffset;

  const PlayerHeader({
    super.key,
    required this.buildPlayer,
    required this.shrinkOffset,
    this.currentTrack,
  });

  @override
  Widget build(BuildContext context) {
    final isShrunk = shrinkOffset > 120;
    final player = buildPlayer(); // ✅ 재사용 보장

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child:
          currentTrack == null
              ? player
              : isShrunk
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: player),
                  const SizedBox(width: 12),
                  Expanded(flex: 3, child: currentTrack!),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [player, const SizedBox(height: 12), currentTrack!],
              ),
    );
  }
}