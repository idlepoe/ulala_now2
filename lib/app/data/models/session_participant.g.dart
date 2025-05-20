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
    );

Map<String, dynamic> _$SessionParticipantToJson(_SessionParticipant instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
    };
