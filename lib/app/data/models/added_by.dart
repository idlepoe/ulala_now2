import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'added_by.freezed.dart';

part 'added_by.g.dart';

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
abstract class AddedBy with _$AddedBy {
  const factory AddedBy({
    @JsonKey(fromJson: _toString) required String uid,
    @JsonKey(fromJson: _toString) required String nickname,
    @JsonKey(fromJson: _toString) required String avatarUrl,
  }) = _AddedBy;

  factory AddedBy.fromJson(Map<String, dynamic> json) =>
      _$AddedByFromJson(json);
}
