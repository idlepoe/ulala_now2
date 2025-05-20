// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'added_by.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddedBy {

@JsonKey(fromJson: _toString) String get uid;@JsonKey(fromJson: _toString) String get nickname;@JsonKey(fromJson: _toString) String get avatarUrl;
/// Create a copy of AddedBy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddedByCopyWith<AddedBy> get copyWith => _$AddedByCopyWithImpl<AddedBy>(this as AddedBy, _$identity);

  /// Serializes this AddedBy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddedBy&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,nickname,avatarUrl);

@override
String toString() {
  return 'AddedBy(uid: $uid, nickname: $nickname, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $AddedByCopyWith<$Res>  {
  factory $AddedByCopyWith(AddedBy value, $Res Function(AddedBy) _then) = _$AddedByCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String uid,@JsonKey(fromJson: _toString) String nickname,@JsonKey(fromJson: _toString) String avatarUrl
});




}
/// @nodoc
class _$AddedByCopyWithImpl<$Res>
    implements $AddedByCopyWith<$Res> {
  _$AddedByCopyWithImpl(this._self, this._then);

  final AddedBy _self;
  final $Res Function(AddedBy) _then;

/// Create a copy of AddedBy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? nickname = null,Object? avatarUrl = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AddedBy implements AddedBy {
  const _AddedBy({@JsonKey(fromJson: _toString) required this.uid, @JsonKey(fromJson: _toString) required this.nickname, @JsonKey(fromJson: _toString) required this.avatarUrl});
  factory _AddedBy.fromJson(Map<String, dynamic> json) => _$AddedByFromJson(json);

@override@JsonKey(fromJson: _toString) final  String uid;
@override@JsonKey(fromJson: _toString) final  String nickname;
@override@JsonKey(fromJson: _toString) final  String avatarUrl;

/// Create a copy of AddedBy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddedByCopyWith<_AddedBy> get copyWith => __$AddedByCopyWithImpl<_AddedBy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddedByToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddedBy&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,nickname,avatarUrl);

@override
String toString() {
  return 'AddedBy(uid: $uid, nickname: $nickname, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$AddedByCopyWith<$Res> implements $AddedByCopyWith<$Res> {
  factory _$AddedByCopyWith(_AddedBy value, $Res Function(_AddedBy) _then) = __$AddedByCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String uid,@JsonKey(fromJson: _toString) String nickname,@JsonKey(fromJson: _toString) String avatarUrl
});




}
/// @nodoc
class __$AddedByCopyWithImpl<$Res>
    implements _$AddedByCopyWith<$Res> {
  __$AddedByCopyWithImpl(this._self, this._then);

  final _AddedBy _self;
  final $Res Function(_AddedBy) _then;

/// Create a copy of AddedBy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? nickname = null,Object? avatarUrl = null,}) {
  return _then(_AddedBy(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
