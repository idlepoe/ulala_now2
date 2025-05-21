// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionTrack {

 String get id; String get videoId;@JsonKey(fromJson: _toString) String get title;@JsonKey(fromJson: _toString) String get description; String get thumbnail;@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime get startAt;@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime get endAt; int get duration;// ✅ 새로 추가됨 (초 단위)
@JsonKey(fromJson: _addedByFromJson) AddedBy get addedBy;// ✅ 구조화된 객체 사용
@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime get createdAt;
/// Create a copy of SessionTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionTrackCopyWith<SessionTrack> get copyWith => _$SessionTrackCopyWithImpl<SessionTrack>(this as SessionTrack, _$identity);

  /// Serializes this SessionTrack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionTrack&&(identical(other.id, id) || other.id == id)&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,videoId,title,description,thumbnail,startAt,endAt,duration,addedBy,createdAt);

@override
String toString() {
  return 'SessionTrack(id: $id, videoId: $videoId, title: $title, description: $description, thumbnail: $thumbnail, startAt: $startAt, endAt: $endAt, duration: $duration, addedBy: $addedBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SessionTrackCopyWith<$Res>  {
  factory $SessionTrackCopyWith(SessionTrack value, $Res Function(SessionTrack) _then) = _$SessionTrackCopyWithImpl;
@useResult
$Res call({
 String id, String videoId,@JsonKey(fromJson: _toString) String title,@JsonKey(fromJson: _toString) String description, String thumbnail,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime startAt,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime endAt, int duration,@JsonKey(fromJson: _addedByFromJson) AddedBy addedBy,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime createdAt
});


$AddedByCopyWith<$Res> get addedBy;

}
/// @nodoc
class _$SessionTrackCopyWithImpl<$Res>
    implements $SessionTrackCopyWith<$Res> {
  _$SessionTrackCopyWithImpl(this._self, this._then);

  final SessionTrack _self;
  final $Res Function(SessionTrack) _then;

/// Create a copy of SessionTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? videoId = null,Object? title = null,Object? description = null,Object? thumbnail = null,Object? startAt = null,Object? endAt = null,Object? duration = null,Object? addedBy = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,addedBy: null == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as AddedBy,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SessionTrack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddedByCopyWith<$Res> get addedBy {
  
  return $AddedByCopyWith<$Res>(_self.addedBy, (value) {
    return _then(_self.copyWith(addedBy: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _SessionTrack implements SessionTrack {
  const _SessionTrack({required this.id, required this.videoId, @JsonKey(fromJson: _toString) required this.title, @JsonKey(fromJson: _toString) required this.description, required this.thumbnail, @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required this.startAt, @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required this.endAt, required this.duration, @JsonKey(fromJson: _addedByFromJson) required this.addedBy, @JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) required this.createdAt});
  factory _SessionTrack.fromJson(Map<String, dynamic> json) => _$SessionTrackFromJson(json);

@override final  String id;
@override final  String videoId;
@override@JsonKey(fromJson: _toString) final  String title;
@override@JsonKey(fromJson: _toString) final  String description;
@override final  String thumbnail;
@override@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) final  DateTime startAt;
@override@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) final  DateTime endAt;
@override final  int duration;
// ✅ 새로 추가됨 (초 단위)
@override@JsonKey(fromJson: _addedByFromJson) final  AddedBy addedBy;
// ✅ 구조화된 객체 사용
@override@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) final  DateTime createdAt;

/// Create a copy of SessionTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionTrackCopyWith<_SessionTrack> get copyWith => __$SessionTrackCopyWithImpl<_SessionTrack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionTrackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionTrack&&(identical(other.id, id) || other.id == id)&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,videoId,title,description,thumbnail,startAt,endAt,duration,addedBy,createdAt);

@override
String toString() {
  return 'SessionTrack(id: $id, videoId: $videoId, title: $title, description: $description, thumbnail: $thumbnail, startAt: $startAt, endAt: $endAt, duration: $duration, addedBy: $addedBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SessionTrackCopyWith<$Res> implements $SessionTrackCopyWith<$Res> {
  factory _$SessionTrackCopyWith(_SessionTrack value, $Res Function(_SessionTrack) _then) = __$SessionTrackCopyWithImpl;
@override @useResult
$Res call({
 String id, String videoId,@JsonKey(fromJson: _toString) String title,@JsonKey(fromJson: _toString) String description, String thumbnail,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime startAt,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime endAt, int duration,@JsonKey(fromJson: _addedByFromJson) AddedBy addedBy,@JsonKey(fromJson: _toDateTime, toJson: _fromDateTime) DateTime createdAt
});


@override $AddedByCopyWith<$Res> get addedBy;

}
/// @nodoc
class __$SessionTrackCopyWithImpl<$Res>
    implements _$SessionTrackCopyWith<$Res> {
  __$SessionTrackCopyWithImpl(this._self, this._then);

  final _SessionTrack _self;
  final $Res Function(_SessionTrack) _then;

/// Create a copy of SessionTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? videoId = null,Object? title = null,Object? description = null,Object? thumbnail = null,Object? startAt = null,Object? endAt = null,Object? duration = null,Object? addedBy = null,Object? createdAt = null,}) {
  return _then(_SessionTrack(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,addedBy: null == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as AddedBy,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SessionTrack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddedByCopyWith<$Res> get addedBy {
  
  return $AddedByCopyWith<$Res>(_self.addedBy, (value) {
    return _then(_self.copyWith(addedBy: value));
  });
}
}

// dart format on
