import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final bool isMine;
  final ThemeData theme;
  final bool isDark;
  final bool isLast;

  const ChatMessageBubble({
    super.key,
    required this.msg,
    required this.isMine,
    required this.theme,
    required this.isDark,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor =
        isMine
            ? (isDark ? Colors.blue[300] : Colors.blue[100])
            : (isDark ? Colors.grey[700] : Colors.grey[200]);

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMine)
              Text(
                msg.senderName,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(msg.message, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 2),
            Text(
              DateFormat.Hm().format(msg.createdAt),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.textTheme.labelSmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
