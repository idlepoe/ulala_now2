// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_sub_snippet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YoutubeSubSnippet _$YoutubeSubSnippetFromJson(Map<String, dynamic> json) =>
    _YoutubeSubSnippet(
      channelId: _toString(json['channelId']),
      title: _toString(json['title']),
      description: _toString(json['description']),
      thumbnails: YoutubeSubThumbnails.fromJson(
        json['thumbnails'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$YoutubeSubSnippetToJson(_YoutubeSubSnippet instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'title': instance.title,
      'description': instance.description,
      'thumbnails': instance.thumbnails,
    };
