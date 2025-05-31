import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'enter_message'.tr),
            onSubmitted: (_) => onSend(),
          ),
        ),
        IconButton(icon: const Icon(Icons.send), onPressed: onSend),
      ],
    );
  }
}
