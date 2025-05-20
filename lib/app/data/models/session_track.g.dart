// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionTrack _$SessionTrackFromJson(Map<String, dynamic> json) =>
    _SessionTrack(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      startAt: _toDateTime(json['startAt']),
      endAt: _toDateTime(json['endAt']),
      duration: (json['duration'] as num).toInt(),
      addedBy: _addedByFromJson(json['addedBy']),
      addedAt: _toDateTime(json['addedAt']),
    );

Map<String, dynamic> _$SessionTrackToJson(_SessionTrack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'title': instance.title,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'startAt': _fromDateTime(instance.startAt),
      'endAt': _fromDateTime(instance.endAt),
      'duration': instance.duration,
      'addedBy': instance.addedBy,
      'addedAt': _fromDateTime(instance.addedAt),
    };
