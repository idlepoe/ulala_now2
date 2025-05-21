// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionParticipant {

 String get uid; String get nickname; String get avatarUrl;@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime get createdAt;@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime get updatedAt;
/// Create a copy of SessionParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionParticipantCopyWith<SessionParticipant> get copyWith => _$SessionParticipantCopyWithImpl<SessionParticipant>(this as SessionParticipant, _$identity);

  /// Serializes this SessionParticipant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionParticipant&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,nickname,avatarUrl,createdAt,updatedAt);

@override
String toString() {
  return 'SessionParticipant(uid: $uid, nickname: $nickname, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SessionParticipantCopyWith<$Res>  {
  factory $SessionParticipantCopyWith(SessionParticipant value, $Res Function(SessionParticipant) _then) = _$SessionParticipantCopyWithImpl;
@useResult
$Res call({
 String uid, String nickname, String avatarUrl,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime createdAt,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime updatedAt
});




}
/// @nodoc
class _$SessionParticipantCopyWithImpl<$Res>
    implements $SessionParticipantCopyWith<$Res> {
  _$SessionParticipantCopyWithImpl(this._self, this._then);

  final SessionParticipant _self;
  final $Res Function(SessionParticipant) _then;

/// Create a copy of SessionParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? nickname = null,Object? avatarUrl = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SessionParticipant implements SessionParticipant {
  const _SessionParticipant({required this.uid, required this.nickname, required this.avatarUrl, @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required this.createdAt, @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required this.updatedAt});
  factory _SessionParticipant.fromJson(Map<String, dynamic> json) => _$SessionParticipantFromJson(json);

@override final  String uid;
@override final  String nickname;
@override final  String avatarUrl;
@override@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) final  DateTime createdAt;
@override@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) final  DateTime updatedAt;

/// Create a copy of SessionParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionParticipantCopyWith<_SessionParticipant> get copyWith => __$SessionParticipantCopyWithImpl<_SessionParticipant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionParticipant&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,nickname,avatarUrl,createdAt,updatedAt);

@override
String toString() {
  return 'SessionParticipant(uid: $uid, nickname: $nickname, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SessionParticipantCopyWith<$Res> implements $SessionParticipantCopyWith<$Res> {
  factory _$SessionParticipantCopyWith(_SessionParticipant value, $Res Function(_SessionParticipant) _then) = __$SessionParticipantCopyWithImpl;
@override @useResult
$Res call({
 String uid, String nickname, String avatarUrl,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime createdAt,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime updatedAt
});




}
/// @nodoc
class __$SessionParticipantCopyWithImpl<$Res>
    implements _$SessionParticipantCopyWith<$Res> {
  __$SessionParticipantCopyWithImpl(this._self, this._then);

  final _SessionParticipant _self;
  final $Res Function(_SessionParticipant) _then;

/// Create a copy of SessionParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? nickname = null,Object? avatarUrl = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SessionParticipant(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
