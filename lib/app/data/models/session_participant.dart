import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_participant.freezed.dart';
part 'session_participant.g.dart';

// null → '' 또는 '값'.toString()
String _toString(dynamic value) =>  value?.toString() ?? '';

// null → 0
int _toInt(dynamic value) => value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

// null → 0.0
double _toDouble(dynamic value) => value is double
    ? value
    : double.tryParse(value?.toString() ?? '') ?? 0.0;

// null → DateTime.now()
DateTime _toDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  return DateTime.now();
}

@freezed
abstract class SessionParticipant with _$SessionParticipant {
  const factory SessionParticipant({
    required String uid,
    required String nickname,
    required String avatarUrl,
  }) = _SessionParticipant;

  factory SessionParticipant.fromJson(Map<String, dynamic> json) => _$SessionParticipantFromJson(json);
}