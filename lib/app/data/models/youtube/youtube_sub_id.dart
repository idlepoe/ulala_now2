import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:html_unescape/html_unescape.dart';

part 'youtube_sub_id.freezed.dart';

// optional: Since our YoutubeSubId class is serializable, we must add this line.
// But if YoutubeSubId was not serializable, we could skip it.
part 'youtube_sub_id.g.dart';

// null → '' 또는 '값'.toString()
String _toString(dynamic value) =>
    value is String ? HtmlUnescape().convert(value) : '';

@freezed
abstract class YoutubeSubId with _$YoutubeSubId {
  const factory YoutubeSubId({
    @JsonKey(fromJson: _toString) required String kind,
    @JsonKey(fromJson: _toString) required String videoId,
  }) = _YoutubeSubId;

  factory YoutubeSubId.fromJson(Map<String, Object?> json) =>
      _$YoutubeSubIdFromJson(json);
}
