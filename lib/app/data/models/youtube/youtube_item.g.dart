// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YoutubeItem _$YoutubeItemFromJson(Map<String, dynamic> json) => _YoutubeItem(
  id: YoutubeSubId.fromJson(json['id'] as Map<String, dynamic>),
  snippet: YoutubeSubSnippet.fromJson(json['snippet'] as Map<String, dynamic>),
);

Map<String, dynamic> _$YoutubeItemToJson(_YoutubeItem instance) =>
    <String, dynamic>{'id': instance.id, 'snippet': instance.snippet};
