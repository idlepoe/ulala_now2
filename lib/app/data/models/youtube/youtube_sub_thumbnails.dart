import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:ulala_now2/app/data/models/youtube/youtube_image.dart';

part 'youtube_sub_thumbnails.freezed.dart';
// optional: Since our YoutubeSubSnippet class is serializable, we must add this line.
// But if YoutubeSubSnippet was not serializable, we could skip it.
part 'youtube_sub_thumbnails.g.dart';

@freezed
abstract class YoutubeSubThumbnails with _$YoutubeSubThumbnails {
  const factory YoutubeSubThumbnails({
    required YoutubeImage medium,
  }) = _YoutubeSubThumbnails;

  factory YoutubeSubThumbnails.fromJson(Map<String, Object?> json)
      => _$YoutubeSubThumbnailsFromJson(json);
}