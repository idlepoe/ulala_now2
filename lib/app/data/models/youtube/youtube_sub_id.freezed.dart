// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_sub_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YoutubeSubId implements DiagnosticableTreeMixin {

@JsonKey(fromJson: _toString) String get kind;@JsonKey(fromJson: _toString) String get videoId;
/// Create a copy of YoutubeSubId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YoutubeSubIdCopyWith<YoutubeSubId> get copyWith => _$YoutubeSubIdCopyWithImpl<YoutubeSubId>(this as YoutubeSubId, _$identity);

  /// Serializes this YoutubeSubId to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'YoutubeSubId'))
    ..add(DiagnosticsProperty('kind', kind))..add(DiagnosticsProperty('videoId', videoId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YoutubeSubId&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.videoId, videoId) || other.videoId == videoId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,videoId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'YoutubeSubId(kind: $kind, videoId: $videoId)';
}


}

/// @nodoc
abstract mixin class $YoutubeSubIdCopyWith<$Res>  {
  factory $YoutubeSubIdCopyWith(YoutubeSubId value, $Res Function(YoutubeSubId) _then) = _$YoutubeSubIdCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String kind,@JsonKey(fromJson: _toString) String videoId
});




}
/// @nodoc
class _$YoutubeSubIdCopyWithImpl<$Res>
    implements $YoutubeSubIdCopyWith<$Res> {
  _$YoutubeSubIdCopyWithImpl(this._self, this._then);

  final YoutubeSubId _self;
  final $Res Function(YoutubeSubId) _then;

/// Create a copy of YoutubeSubId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? videoId = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _YoutubeSubId with DiagnosticableTreeMixin implements YoutubeSubId {
  const _YoutubeSubId({@JsonKey(fromJson: _toString) required this.kind, @JsonKey(fromJson: _toString) required this.videoId});
  factory _YoutubeSubId.fromJson(Map<String, dynamic> json) => _$YoutubeSubIdFromJson(json);

@override@JsonKey(fromJson: _toString) final  String kind;
@override@JsonKey(fromJson: _toString) final  String videoId;

/// Create a copy of YoutubeSubId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YoutubeSubIdCopyWith<_YoutubeSubId> get copyWith => __$YoutubeSubIdCopyWithImpl<_YoutubeSubId>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YoutubeSubIdToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'YoutubeSubId'))
    ..add(DiagnosticsProperty('kind', kind))..add(DiagnosticsProperty('videoId', videoId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YoutubeSubId&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.videoId, videoId) || other.videoId == videoId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,videoId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'YoutubeSubId(kind: $kind, videoId: $videoId)';
}


}

/// @nodoc
abstract mixin class _$YoutubeSubIdCopyWith<$Res> implements $YoutubeSubIdCopyWith<$Res> {
  factory _$YoutubeSubIdCopyWith(_YoutubeSubId value, $Res Function(_YoutubeSubId) _then) = __$YoutubeSubIdCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String kind,@JsonKey(fromJson: _toString) String videoId
});




}
/// @nodoc
class __$YoutubeSubIdCopyWithImpl<$Res>
    implements _$YoutubeSubIdCopyWith<$Res> {
  __$YoutubeSubIdCopyWithImpl(this._self, this._then);

  final _YoutubeSubId _self;
  final $Res Function(_YoutubeSubId) _then;

/// Create a copy of YoutubeSubId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? videoId = null,}) {
  return _then(_YoutubeSubId(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
