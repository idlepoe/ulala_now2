import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/logger.dart';

part 'chat_message.freezed.dart';

part 'chat_message.g.dart';

// null → '' 또는 '값'.toString()
String _toString(dynamic value) => value is String ? value : "";

// null → 0
int _toInt(dynamic value) =>
    value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

// null → 0.0
double _toDouble(dynamic value) =>
    value is double ? value : double.tryParse(value?.toString() ?? '') ?? 0.0;

DateTime _toDateTime(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is Map &&
      value.containsKey('_seconds') &&
      value.containsKey('_nanoseconds')) {
    return DateTime.fromMillisecondsSinceEpoch(
      (value['_seconds'] as int) * 1000,
    );
  }
  return value as DateTime;
}

dynamic _fromDateTime(DateTime dateTime) {
  return dateTime.toIso8601String();
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String senderId,
    required String senderName,
    required String message,
    @JsonKey(fromJson: _toDateTime) required DateTime createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
