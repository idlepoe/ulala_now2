// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  id: json['id'] as String,
  name: json['name'] as String,
  createdAt: _toDateTime(json['createdAt']),
  updatedAt: _toDateTime(json['updatedAt']),
  trackList: _toTrackList(json['trackList']),
  participants: _toParticipantList(json['participants']),
  participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
  mode:
      $enumDecodeNullable(_$SessionModeEnumMap, json['mode']) ??
      SessionMode.general,
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'trackList': instance.trackList,
  'participants': instance.participants,
  'participantCount': instance.participantCount,
  'mode': _$SessionModeEnumMap[instance.mode]!,
};

const _$SessionModeEnumMap = {
  SessionMode.general: 'general',
  SessionMode.dj: 'dj',
  SessionMode.shuffle: 'shuffle',
};
