// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Session {

 String get id; String get name;@JsonKey(fromJson: _toDateTime) DateTime get createdAt;@JsonKey(fromJson: _toDateTime) DateTime get updatedAt;@JsonKey(fromJson: _toTrackList) List<SessionTrack> get trackList;@JsonKey(fromJson: _toParticipantList) List<SessionParticipant> get participants;// ✅ 여기가 중요
 int get participantCount;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.trackList, trackList)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,updatedAt,const DeepCollectionEquality().hash(trackList),const DeepCollectionEquality().hash(participants),participantCount);

@override
String toString() {
  return 'Session(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, trackList: $trackList, participants: $participants, participantCount: $participantCount)';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(fromJson: _toDateTime) DateTime createdAt,@JsonKey(fromJson: _toDateTime) DateTime updatedAt,@JsonKey(fromJson: _toTrackList) List<SessionTrack> trackList,@JsonKey(fromJson: _toParticipantList) List<SessionParticipant> participants, int participantCount
});




}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? trackList = null,Object? participants = null,Object? participantCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,trackList: null == trackList ? _self.trackList : trackList // ignore: cast_nullable_to_non_nullable
as List<SessionTrack>,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<SessionParticipant>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Session implements Session {
  const _Session({required this.id, required this.name, @JsonKey(fromJson: _toDateTime) required this.createdAt, @JsonKey(fromJson: _toDateTime) required this.updatedAt, @JsonKey(fromJson: _toTrackList) required final  List<SessionTrack> trackList, @JsonKey(fromJson: _toParticipantList) required final  List<SessionParticipant> participants, this.participantCount = 0}): _trackList = trackList,_participants = participants;
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(fromJson: _toDateTime) final  DateTime createdAt;
@override@JsonKey(fromJson: _toDateTime) final  DateTime updatedAt;
 final  List<SessionTrack> _trackList;
@override@JsonKey(fromJson: _toTrackList) List<SessionTrack> get trackList {
  if (_trackList is EqualUnmodifiableListView) return _trackList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trackList);
}

 final  List<SessionParticipant> _participants;
@override@JsonKey(fromJson: _toParticipantList) List<SessionParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

// ✅ 여기가 중요
@override@JsonKey() final  int participantCount;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._trackList, _trackList)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,updatedAt,const DeepCollectionEquality().hash(_trackList),const DeepCollectionEquality().hash(_participants),participantCount);

@override
String toString() {
  return 'Session(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, trackList: $trackList, participants: $participants, participantCount: $participantCount)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(fromJson: _toDateTime) DateTime createdAt,@JsonKey(fromJson: _toDateTime) DateTime updatedAt,@JsonKey(fromJson: _toTrackList) List<SessionTrack> trackList,@JsonKey(fromJson: _toParticipantList) List<SessionParticipant> participants, int participantCount
});




}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? trackList = null,Object? participants = null,Object? participantCount = null,}) {
  return _then(_Session(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,trackList: null == trackList ? _self._trackList : trackList // ignore: cast_nullable_to_non_nullable
as List<SessionTrack>,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<SessionParticipant>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
