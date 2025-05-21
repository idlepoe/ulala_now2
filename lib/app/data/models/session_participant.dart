import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_participant.freezed.dart';
part 'session_participant.g.dart';

String _toString(dynamic value) =>  value?.toString() ?? '';

int _toInt(dynamic value) => value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

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

@freezed
abstract class SessionParticipant with _$SessionParticipant {
  const factory SessionParticipant({
    required String uid,
    required String nickname,
    required String avatarUrl,
    @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required DateTime createdAt,
    @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required DateTime updatedAt,
  }) = _SessionParticipant;

  factory SessionParticipant.fromJson(Map<String, dynamic> json) => _$SessionParticipantFromJson(json);
}