import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ulala_now2/app/data/models/youtube/youtube_sub_id.dart';
import 'package:ulala_now2/app/data/models/youtube/youtube_sub_snippet.dart';

part 'youtube_item.freezed.dart';
// optional: Since our YoutubeItem class is serializable, we must add this line.
// But if YoutubeItem was not serializable, we could skip it.
part 'youtube_item.g.dart';

@freezed
abstract class YoutubeItem with _$YoutubeItem {
  const factory YoutubeItem({
    required YoutubeSubId id,
    required YoutubeSubSnippet snippet,
  }) = _YoutubeItem;

  factory YoutubeItem.fromJson(Map<String, Object?> json)
      => _$YoutubeItemFromJson(json);
}