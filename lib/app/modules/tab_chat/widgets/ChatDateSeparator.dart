import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDateSeparator extends StatelessWidget {
  final DateTime date;

  const ChatDateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        DateFormat.yMMMMEEEEd('ko_KR').format(date),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
