// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionParticipant _$SessionParticipantFromJson(Map<String, dynamic> json) =>
    _SessionParticipant(
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: json['avatarUrl'] as String,
      createdAt: _toDateTime(json['createdAt']),
      updatedAt: _toDateTime(json['updatedAt']),
    );

Map<String, dynamic> _$SessionParticipantToJson(_SessionParticipant instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
      'createdAt': _fromDateTime(instance.createdAt),
      'updatedAt': _fromDateTime(instance.updatedAt),
    };
