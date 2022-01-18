import 'package:dart_twitter_api/twitter_api.dart';
import 'package:write_only_twitter/src/models/media_data.dart';
import 'package:write_only_twitter/src/models/media_type.dart';

class TweetData {
  String? id;
  String? text;
  String? url;
  List<ImageData> imgs;

  TweetData(
      {required this.id,
      required this.text,
      required this.url,
      required this.imgs});
}

TweetData constructTweetDateFromTweet(Tweet tweet) {
  List<ImageData>? images;

  if (tweet.extendedEntities?.media != null &&
      tweet.extendedEntities!.media!.isNotEmpty) {
    for (final media in tweet.extendedEntities!.media!) {
      if (media.type == kMediaPhoto) {
        images ??= [];
        images.add(ImageData.fromMedia(media));
      }
    }
  }

  return TweetData(
      id: tweet.idStr,
      text: tweet.fullText,
      url: tweet.source,
      imgs: images ?? []);
}
