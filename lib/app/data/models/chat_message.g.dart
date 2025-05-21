// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String,
  message: json['message'] as String,
  createdAt: _toDateTime(json['createdAt']),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
    };
