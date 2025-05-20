import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html_unescape/html_unescape.dart';

import 'added_by.dart';

part 'session_track.freezed.dart';
part 'session_track.g.dart';

// null → '' 또는 '값'.toString()
String _toString(dynamic value) =>
    value is String ? HtmlUnescape().convert(value) : '';

// null → 0
int _toInt(dynamic value) => value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

// null → 0.0
double _toDouble(dynamic value) => value is double
    ? value
    : double.tryParse(value?.toString() ?? '') ?? 0.0;

DateTime _toDateTime(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is Map &&
      value.containsKey('_seconds') &&
      value.containsKey('_nanoseconds')) {
    return DateTime.fromMillisecondsSinceEpoch(
        (value['_seconds'] as int) * 1000);
  }
  return value as DateTime;
}

dynamic _fromDateTime(DateTime dateTime) {
  return dateTime.toIso8601String();
}

AddedBy _addedByFromJson(dynamic json) {
  if (json is String) {
    return AddedBy(uid: json, nickname: '', avatarUrl: '');
  } else if (json is Map<String, dynamic>) {
    return AddedBy.fromJson(json);
  } else {
    throw Exception('Invalid addedBy format');
  }
}
@freezed
abstract class SessionTrack with _$SessionTrack {
  const factory SessionTrack({
    required String id,
    required String videoId,
    @JsonKey(fromJson: _toString) required String title,
    @JsonKey(fromJson: _toString) required String description,
    required String thumbnail,
    @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required DateTime startAt,
    @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required DateTime endAt,
    required int duration, // ✅ 새로 추가됨 (초 단위)
    @JsonKey(fromJson: _addedByFromJson) required AddedBy addedBy, // ✅ 구조화된 객체 사용
    @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required DateTime addedAt,
  }) = _SessionTrack;

  factory SessionTrack.fromJson(Map<String, dynamic> json) =>
      _$SessionTrackFromJson(json);
}
