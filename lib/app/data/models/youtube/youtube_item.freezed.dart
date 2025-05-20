// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YoutubeItem {

 YoutubeSubId get id; YoutubeSubSnippet get snippet;
/// Create a copy of YoutubeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YoutubeItemCopyWith<YoutubeItem> get copyWith => _$YoutubeItemCopyWithImpl<YoutubeItem>(this as YoutubeItem, _$identity);

  /// Serializes this YoutubeItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YoutubeItem&&(identical(other.id, id) || other.id == id)&&(identical(other.snippet, snippet) || other.snippet == snippet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,snippet);

@override
String toString() {
  return 'YoutubeItem(id: $id, snippet: $snippet)';
}


}

/// @nodoc
abstract mixin class $YoutubeItemCopyWith<$Res>  {
  factory $YoutubeItemCopyWith(YoutubeItem value, $Res Function(YoutubeItem) _then) = _$YoutubeItemCopyWithImpl;
@useResult
$Res call({
 YoutubeSubId id, YoutubeSubSnippet snippet
});


$YoutubeSubIdCopyWith<$Res> get id;$YoutubeSubSnippetCopyWith<$Res> get snippet;

}
/// @nodoc
class _$YoutubeItemCopyWithImpl<$Res>
    implements $YoutubeItemCopyWith<$Res> {
  _$YoutubeItemCopyWithImpl(this._self, this._then);

  final YoutubeItem _self;
  final $Res Function(YoutubeItem) _then;

/// Create a copy of YoutubeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? snippet = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as YoutubeSubId,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as YoutubeSubSnippet,
  ));
}
/// Create a copy of YoutubeItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YoutubeSubIdCopyWith<$Res> get id {
  
  return $YoutubeSubIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of YoutubeItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YoutubeSubSnippetCopyWith<$Res> get snippet {
  
  return $YoutubeSubSnippetCopyWith<$Res>(_self.snippet, (value) {
    return _then(_self.copyWith(snippet: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _YoutubeItem implements YoutubeItem {
  const _YoutubeItem({required this.id, required this.snippet});
  factory _YoutubeItem.fromJson(Map<String, dynamic> json) => _$YoutubeItemFromJson(json);

@override final  YoutubeSubId id;
@override final  YoutubeSubSnippet snippet;

/// Create a copy of YoutubeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YoutubeItemCopyWith<_YoutubeItem> get copyWith => __$YoutubeItemCopyWithImpl<_YoutubeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YoutubeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YoutubeItem&&(identical(other.id, id) || other.id == id)&&(identical(other.snippet, snippet) || other.snippet == snippet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,snippet);

@override
String toString() {
  return 'YoutubeItem(id: $id, snippet: $snippet)';
}


}

/// @nodoc
abstract mixin class _$YoutubeItemCopyWith<$Res> implements $YoutubeItemCopyWith<$Res> {
  factory _$YoutubeItemCopyWith(_YoutubeItem value, $Res Function(_YoutubeItem) _then) = __$YoutubeItemCopyWithImpl;
@override @useResult
$Res call({
 YoutubeSubId id, YoutubeSubSnippet snippet
});


@override $YoutubeSubIdCopyWith<$Res> get id;@override $YoutubeSubSnippetCopyWith<$Res> get snippet;

}
/// @nodoc
class __$YoutubeItemCopyWithImpl<$Res>
    implements _$YoutubeItemCopyWith<$Res> {
  __$YoutubeItemCopyWithImpl(this._self, this._then);

  final _YoutubeItem _self;
  final $Res Function(_YoutubeItem) _then;

/// Create a copy of YoutubeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? snippet = null,}) {
  return _then(_YoutubeItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as YoutubeSubId,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as YoutubeSubSnippet,
  ));
}

/// Create a copy of YoutubeItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YoutubeSubIdCopyWith<$Res> get id {
  
  return $YoutubeSubIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of YoutubeItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YoutubeSubSnippetCopyWith<$Res> get snippet {
  
  return $YoutubeSubSnippetCopyWith<$Res>(_self.snippet, (value) {
    return _then(_self.copyWith(snippet: value));
  });
}
}

// dart format on
