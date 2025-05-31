import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/chat_message.dart';
import 'ChatDateSeparator.dart';
import 'ChatMessageBubble.dart';

class ChatMessageListView extends StatelessWidget {
  final List<ChatMessage> messages;
  final String userId;

  const ChatMessageListView({
    super.key,
    required this.messages,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (_, index) {
        final msg = messages[messages.length - 1 - index];
        final isMine = msg.senderId == userId;

        final currentDate = DateFormat('yyyy-MM-dd').format(msg.createdAt);
        final prevDate =
            index < messages.length - 1
                ? DateFormat(
                  'yyyy-MM-dd',
                ).format(messages[messages.length - index - 2].createdAt)
                : null;
        final needsDateSeparator = currentDate != prevDate;

        return Column(
          children: [
            if (needsDateSeparator) ChatDateSeparator(date: msg.createdAt),
            ChatMessageBubble(
              msg: msg,
              isMine: isMine,
              theme: theme,
              isDark: isDark,
              isLast: index == 0,
            ),
          ],
        );
      },
    );
  }
}
