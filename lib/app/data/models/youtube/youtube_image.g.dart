// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YoutubeImage _$YoutubeImageFromJson(Map<String, dynamic> json) =>
    _YoutubeImage(
      url: _toString(json['url']),
      width: _toInt(json['width']),
      height: _toInt(json['height']),
    );

Map<String, dynamic> _$YoutubeImageToJson(_YoutubeImage instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
