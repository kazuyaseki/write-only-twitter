import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';

final TweetsState =
    StateNotifierProvider<Tweets, List<TweetData>>((_) => Tweets());

class Tweets extends StateNotifier<List<TweetData>> {
  Tweets() : super([]);

  void setNewTweets(List<TweetData> newTweets) => {state = newTweets};

  void postTweet(TweetData newTweet) => {
        state = [newTweet, ...state]
      };
}
