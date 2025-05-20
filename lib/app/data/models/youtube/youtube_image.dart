import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html_unescape/html_unescape.dart';

part 'youtube_image.freezed.dart';
// optional: Since our YoutubeImage class is serializable, we must add this line.
// But if YoutubeImage was not serializable, we could skip it.
part 'youtube_image.g.dart';

// null → '' 또는 '값'.toString()
String _toString(dynamic value) =>
    value is String ? HtmlUnescape().convert(value) : '';
// null → 0
int _toInt(dynamic value) =>
    value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;


@freezed
abstract class YoutubeImage with _$YoutubeImage {
  const factory YoutubeImage({
    @JsonKey(fromJson: _toString) required String url,
    @JsonKey(fromJson: _toInt) required int width,
    @JsonKey(fromJson: _toInt) required int height,
  }) = _YoutubeImage;

  factory YoutubeImage.fromJson(Map<String, Object?> json)
  => _$YoutubeImageFromJson(json);
}