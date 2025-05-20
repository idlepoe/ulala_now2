import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:ulala_now2/app/data/models/youtube/youtube_sub_thumbnails.dart';

part 'youtube_sub_snippet.freezed.dart';

// optional: Since our YoutubeSubSnippet class is serializable, we must add this line.
// But if YoutubeSubSnippet was not serializable, we could skip it.
part 'youtube_sub_snippet.g.dart';

String _toString(dynamic value) =>
    value is String ? HtmlUnescape().convert(value) : '';

@freezed
abstract class YoutubeSubSnippet with _$YoutubeSubSnippet {
  const factory YoutubeSubSnippet({
    @JsonKey(fromJson: _toString) required String channelId,
    @JsonKey(fromJson: _toString) required String title,
    @JsonKey(fromJson: _toString) required String description,
    required YoutubeSubThumbnails thumbnails,
  }) = _YoutubeSubSnippet;

  factory YoutubeSubSnippet.fromJson(Map<String, Object?> json) =>
      _$YoutubeSubSnippetFromJson(json);
}
