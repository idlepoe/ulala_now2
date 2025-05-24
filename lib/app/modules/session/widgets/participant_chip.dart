import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/models/session.dart';
import '../../../data/models/session_participant.dart';
import '../controllers/session_controller.dart';
import 'build_avatar.dart';

class ParticipantChip extends StatelessWidget {
  final SessionParticipant participant;
  final double size;

  const ParticipantChip({
    super.key,
    required this.participant,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<SessionController>();
    final isDJ =
        controller.session.value!.mode == SessionMode.dj &&
        controller.canControlTrack(participants: participant);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.65),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.grey.shade300,
                ),
                boxShadow:
                    isDark
                        ? []
                        : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildAvatar(
                    url: participant.avatarUrl,
                    nickname: participant.nickname,
                    size: size,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        participant.nickname,
                        style: TextStyle(
                          fontSize: size * 0.6,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        _statusText(participant),
                        style: TextStyle(
                          fontSize: size * 0.4,
                          color:
                              isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // ✅ DJ 표시
        if (isDJ)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/mode_dj.png',
                    width: 14,
                    height: 14,
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    'DJ',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _statusText(SessionParticipant p) {
    final duration = DateTime.now().difference(p.updatedAt);
    if (duration.inMinutes < 5) return '방금 활동함';
    if (duration.inMinutes < 60) return '${duration.inMinutes}분 전 활동';
    if (duration.inHours < 24) return '${duration.inHours}시간 전 활동';
    return '오래됨';
  }
}
