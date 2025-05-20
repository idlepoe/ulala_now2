// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_sub_thumbnails.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YoutubeSubThumbnails implements DiagnosticableTreeMixin {

 YoutubeImage get medium;
/// Create a copy of YoutubeSubThumbnails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YoutubeSubThumbnailsCopyWith<YoutubeSubThumbnails> get copyWith => _$YoutubeSubThumbnailsCopyWithImpl<YoutubeSubThumbnails>(this as YoutubeSubThumbnails, _$identity);

  /// Serializes this YoutubeSubThumbnails to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'YoutubeSubThumbnails'))
    ..add(DiagnosticsProperty('medium', medium));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YoutubeSubThumbnails&&(identical(other.medium, medium) || other.medium == medium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medium);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'YoutubeSubThumbnails(medium: $medium)';
}


}

/// @nodoc
abstract mixin class $YoutubeSubThumbnailsCopyWith<$Res>  {
  factory $YoutubeSubThumbnailsCopyWith(YoutubeSubThumbnails value, $Res Function(YoutubeSubThumbnails) _then) = _$YoutubeSubThumbnailsCopyWithImpl;
@useResult
$Res call({
 YoutubeImage medium
});


$YoutubeImageCopyWith<$Res> get medium;

}
/// @nodoc
class _$YoutubeSubThumbnailsCopyWithImpl<$Res>
    implements $YoutubeSubThumbnailsCopyWith<$Res> {
  _$YoutubeSubThumbnailsCopyWithImpl(this._self, this._then);

  final YoutubeSubThumbnails _self;
  final $Res Function(YoutubeSubThumbnails) _then;

/// Create a copy of YoutubeSubThumbnails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medium = null,}) {
  return _then(_self.copyWith(
medium: null == medium ? _self.medium : medium // ignore: cast_nullable_to_non_nullable
as YoutubeImage,
  ));
}
/// Create a copy of YoutubeSubThumbnails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YoutubeImageCopyWith<$Res> get medium {
  
  return $YoutubeImageCopyWith<$Res>(_self.medium, (value) {
    return _then(_self.copyWith(medium: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _YoutubeSubThumbnails with DiagnosticableTreeMixin implements YoutubeSubThumbnails {
  const _YoutubeSubThumbnails({required this.medium});
  factory _YoutubeSubThumbnails.fromJson(Map<String, dynamic> json) => _$YoutubeSubThumbnailsFromJson(json);

@override final  YoutubeImage medium;

/// Create a copy of YoutubeSubThumbnails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YoutubeSubThumbnailsCopyWith<_YoutubeSubThumbnails> get copyWith => __$YoutubeSubThumbnailsCopyWithImpl<_YoutubeSubThumbnails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YoutubeSubThumbnailsToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'YoutubeSubThumbnails'))
    ..add(DiagnosticsProperty('medium', medium));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YoutubeSubThumbnails&&(identical(other.medium, medium) || other.medium == medium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medium);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'YoutubeSubThumbnails(medium: $medium)';
}


}

/// @nodoc
abstract mixin class _$YoutubeSubThumbnailsCopyWith<$Res> implements $YoutubeSubThumbnailsCopyWith<$Res> {
  factory _$YoutubeSubThumbnailsCopyWith(_YoutubeSubThumbnails value, $Res Function(_YoutubeSubThumbnails) _then) = __$YoutubeSubThumbnailsCopyWithImpl;
@override @useResult
$Res call({
 YoutubeImage medium
});


@override $YoutubeImageCopyWith<$Res> get medium;

}
/// @nodoc
class __$YoutubeSubThumbnailsCopyWithImpl<$Res>
    implements _$YoutubeSubThumbnailsCopyWith<$Res> {
  __$YoutubeSubThumbnailsCopyWithImpl(this._self, this._then);

  final _YoutubeSubThumbnails _self;
  final $Res Function(_YoutubeSubThumbnails) _then;

/// Create a copy of YoutubeSubThumbnails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medium = null,}) {
  return _then(_YoutubeSubThumbnails(
medium: null == medium ? _self.medium : medium // ignore: cast_nullable_to_non_nullable
as YoutubeImage,
  ));
}

/// Create a copy of YoutubeSubThumbnails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YoutubeImageCopyWith<$Res> get medium {
  
  return $YoutubeImageCopyWith<$Res>(_self.medium, (value) {
    return _then(_self.copyWith(medium: value));
  });
}
}

// dart format on
