// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_sub_snippet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YoutubeSubSnippet implements DiagnosticableTreeMixin {

@JsonKey(fromJson: _toString) String get channelId;@JsonKey(fromJson: _toString) String get title;@JsonKey(fromJson: _toString) String get description; YoutubeSubThumbnails get thumbnails;
/// Create a copy of YoutubeSubSnippet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YoutubeSubSnippetCopyWith<YoutubeSubSnippet> get copyWith => _$YoutubeSubSnippetCopyWithImpl<YoutubeSubSnippet>(this as YoutubeSubSnippet, _$identity);

  /// Serializes this YoutubeSubSnippet to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'YoutubeSubSnippet'))
    ..add(DiagnosticsProperty('channelId', channelId))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('thumbnails', thumbnails));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YoutubeSubSnippet&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnails, thumbnails) || other.thumbnails == thumbnails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,channelId,title,description,thumbnails);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'YoutubeSubSnippet(channelId: $channelId, title: $title, description: $description, thumbnails: $thumbnails)';
}


}

/// @nodoc
abstract mixin class $YoutubeSubSnippetCopyWith<$Res>  {
  factory $YoutubeSubSnippetCopyWith(YoutubeSubSnippet value, $Res Function(YoutubeSubSnippet) _then) = _$YoutubeSubSnippetCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String channelId,@JsonKey(fromJson: _toString) String title,@JsonKey(fromJson: _toString) String description, YoutubeSubThumbnails thumbnails
});


$YoutubeSubThumbnailsCopyWith<$Res> get thumbnails;

}
/// @nodoc
class _$YoutubeSubSnippetCopyWithImpl<$Res>
    implements $YoutubeSubSnippetCopyWith<$Res> {
  _$YoutubeSubSnippetCopyWithImpl(this._self, this._then);

  final YoutubeSubSnippet _self;
  final $Res Function(YoutubeSubSnippet) _then;

/// Create a copy of YoutubeSubSnippet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channelId = null,Object? title = null,Object? description = null,Object? thumbnails = null,}) {
  return _then(_self.copyWith(
channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,thumbnails: null == thumbnails ? _self.thumbnails : thumbnails // ignore: cast_nullable_to_non_nullable
as YoutubeSubThumbnails,
  ));
}
/// Create a copy of YoutubeSubSnippet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YoutubeSubThumbnailsCopyWith<$Res> get thumbnails {
  
  return $YoutubeSubThumbnailsCopyWith<$Res>(_self.thumbnails, (value) {
    return _then(_self.copyWith(thumbnails: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _YoutubeSubSnippet with DiagnosticableTreeMixin implements YoutubeSubSnippet {
  const _YoutubeSubSnippet({@JsonKey(fromJson: _toString) required this.channelId, @JsonKey(fromJson: _toString) required this.title, @JsonKey(fromJson: _toString) required this.description, required this.thumbnails});
  factory _YoutubeSubSnippet.fromJson(Map<String, dynamic> json) => _$YoutubeSubSnippetFromJson(json);

@override@JsonKey(fromJson: _toString) final  String channelId;
@override@JsonKey(fromJson: _toString) final  String title;
@override@JsonKey(fromJson: _toString) final  String description;
@override final  YoutubeSubThumbnails thumbnails;

/// Create a copy of YoutubeSubSnippet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YoutubeSubSnippetCopyWith<_YoutubeSubSnippet> get copyWith => __$YoutubeSubSnippetCopyWithImpl<_YoutubeSubSnippet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YoutubeSubSnippetToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'YoutubeSubSnippet'))
    ..add(DiagnosticsProperty('channelId', channelId))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('thumbnails', thumbnails));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YoutubeSubSnippet&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnails, thumbnails) || other.thumbnails == thumbnails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,channelId,title,description,thumbnails);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'YoutubeSubSnippet(channelId: $channelId, title: $title, description: $description, thumbnails: $thumbnails)';
}


}

/// @nodoc
abstract mixin class _$YoutubeSubSnippetCopyWith<$Res> implements $YoutubeSubSnippetCopyWith<$Res> {
  factory _$YoutubeSubSnippetCopyWith(_YoutubeSubSnippet value, $Res Function(_YoutubeSubSnippet) _then) = __$YoutubeSubSnippetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String channelId,@JsonKey(fromJson: _toString) String title,@JsonKey(fromJson: _toString) String description, YoutubeSubThumbnails thumbnails
});


@override $YoutubeSubThumbnailsCopyWith<$Res> get thumbnails;

}
/// @nodoc
class __$YoutubeSubSnippetCopyWithImpl<$Res>
    implements _$YoutubeSubSnippetCopyWith<$Res> {
  __$YoutubeSubSnippetCopyWithImpl(this._self, this._then);

  final _YoutubeSubSnippet _self;
  final $Res Function(_YoutubeSubSnippet) _then;

/// Create a copy of YoutubeSubSnippet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channelId = null,Object? title = null,Object? description = null,Object? thumbnails = null,}) {
  return _then(_YoutubeSubSnippet(
channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,thumbnails: null == thumbnails ? _self.thumbnails : thumbnails // ignore: cast_nullable_to_non_nullable
as YoutubeSubThumbnails,
  ));
}

/// Create a copy of YoutubeSubSnippet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YoutubeSubThumbnailsCopyWith<$Res> get thumbnails {
  
  return $YoutubeSubThumbnailsCopyWith<$Res>(_self.thumbnails, (value) {
    return _then(_self.copyWith(thumbnails: value));
  });
}
}

// dart format on
