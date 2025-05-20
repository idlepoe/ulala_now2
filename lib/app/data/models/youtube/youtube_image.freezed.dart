// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YoutubeImage {

@JsonKey(fromJson: _toString) String get url;@JsonKey(fromJson: _toInt) int get width;@JsonKey(fromJson: _toInt) int get height;
/// Create a copy of YoutubeImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YoutubeImageCopyWith<YoutubeImage> get copyWith => _$YoutubeImageCopyWithImpl<YoutubeImage>(this as YoutubeImage, _$identity);

  /// Serializes this YoutubeImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YoutubeImage&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,width,height);

@override
String toString() {
  return 'YoutubeImage(url: $url, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $YoutubeImageCopyWith<$Res>  {
  factory $YoutubeImageCopyWith(YoutubeImage value, $Res Function(YoutubeImage) _then) = _$YoutubeImageCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String url,@JsonKey(fromJson: _toInt) int width,@JsonKey(fromJson: _toInt) int height
});




}
/// @nodoc
class _$YoutubeImageCopyWithImpl<$Res>
    implements $YoutubeImageCopyWith<$Res> {
  _$YoutubeImageCopyWithImpl(this._self, this._then);

  final YoutubeImage _self;
  final $Res Function(YoutubeImage) _then;

/// Create a copy of YoutubeImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _YoutubeImage implements YoutubeImage {
  const _YoutubeImage({@JsonKey(fromJson: _toString) required this.url, @JsonKey(fromJson: _toInt) required this.width, @JsonKey(fromJson: _toInt) required this.height});
  factory _YoutubeImage.fromJson(Map<String, dynamic> json) => _$YoutubeImageFromJson(json);

@override@JsonKey(fromJson: _toString) final  String url;
@override@JsonKey(fromJson: _toInt) final  int width;
@override@JsonKey(fromJson: _toInt) final  int height;

/// Create a copy of YoutubeImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YoutubeImageCopyWith<_YoutubeImage> get copyWith => __$YoutubeImageCopyWithImpl<_YoutubeImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YoutubeImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YoutubeImage&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,width,height);

@override
String toString() {
  return 'YoutubeImage(url: $url, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$YoutubeImageCopyWith<$Res> implements $YoutubeImageCopyWith<$Res> {
  factory _$YoutubeImageCopyWith(_YoutubeImage value, $Res Function(_YoutubeImage) _then) = __$YoutubeImageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String url,@JsonKey(fromJson: _toInt) int width,@JsonKey(fromJson: _toInt) int height
});




}
/// @nodoc
class __$YoutubeImageCopyWithImpl<$Res>
    implements _$YoutubeImageCopyWith<$Res> {
  __$YoutubeImageCopyWithImpl(this._self, this._then);

  final _YoutubeImage _self;
  final $Res Function(_YoutubeImage) _then;

/// Create a copy of YoutubeImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? width = null,Object? height = null,}) {
  return _then(_YoutubeImage(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
