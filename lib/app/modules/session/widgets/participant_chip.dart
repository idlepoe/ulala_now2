import 'package:flutter/material.dart';

import '../../../data/models/session_participant.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade400),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 3,
            offset: const Offset(0, 2),
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
                ),
              ),
              Text(
                _statusText(participant),
                style: TextStyle(
                  fontSize: size * 0.4,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
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
