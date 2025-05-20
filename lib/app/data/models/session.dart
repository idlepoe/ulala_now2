import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ulala_now2/app/data/models/session_participant.dart';
import 'package:ulala_now2/app/data/models/session_track.dart';

part 'session.freezed.dart';

part 'session.g.dart';

// null → '' 또는 '값'.toString()
String _toString(dynamic value) => value?.toString() ?? '';

// null → 0
int _toInt(dynamic value) =>
    value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

// null → 0.0
double _toDouble(dynamic value) =>
    value is double ? value : double.tryParse(value?.toString() ?? '') ?? 0.0;

// null → DateTime.now()
DateTime _toDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  if (value is Map &&
      value.containsKey('_seconds') &&
      value.containsKey('_nanoseconds')) {
    return DateTime.fromMillisecondsSinceEpoch(
        (value['_seconds'] as int) * 1000);
  }
  return DateTime.now();
}
List<SessionTrack> _toTrackList(dynamic json) {
  if (json is List) {
    return json.map((e) => SessionTrack.fromJson(Map<String, dynamic>.from(e))).toList();
  }
  return [];
}

List<SessionParticipant> _toParticipantList(dynamic json) {
  if (json is List) {
    return json.map((e) => SessionParticipant.fromJson(Map<String, dynamic>.from(e))).toList();
  }
  return [];
}
@freezed
abstract class Session with _$Session {
  const factory Session({
    required String id,
    required String name,
    @JsonKey(fromJson: _toDateTime) required DateTime createdAt,
    @JsonKey(fromJson: _toDateTime) required DateTime updatedAt,
    @JsonKey(fromJson: _toTrackList)required List<SessionTrack> trackList,
    @JsonKey(fromJson: _toParticipantList)required List<SessionParticipant> participants, // ✅ 여기가 중요
    @Default(0) int participantCount, // ✅ participantCount 추가, 기본값 0
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
