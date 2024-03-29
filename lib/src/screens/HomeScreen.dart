import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:write_only_twitter/src/components/Button.dart';
import 'package:write_only_twitter/src/components/CreateTweetModal.dart';
import 'package:write_only_twitter/src/components/TweetContent.dart';
import 'package:write_only_twitter/src/components/TweetSkeleton.dart';
import 'package:write_only_twitter/src/globalStates/TweetsState.dart';
import 'package:write_only_twitter/src/globalStates/UserProfileState.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';
import 'package:write_only_twitter/src/models/UserProfile.dart';
import 'package:write_only_twitter/src/service/twitter_api_service.dart';
import 'package:write_only_twitter/src/service/twitter_auth_token_service.dart';
import 'package:write_only_twitter/src/theme/colors.dart';
import 'package:write_only_twitter/src/theme/typography.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  _fetchOwnTweets(WidgetRef ref, VoidCallback onFinished) async {
    TwitterApi? client = await TwitterApiService().getClient();
    if (client == null) {
      return;
    }

    final userId = await TwitterAuthTokenService().getTwitterUserId();

    final ownTweets =
        await client.timelineService.userTimeline(userId: userId, count: 10);

    if (ownTweets.isNotEmpty) {
      Tweet tweet = ownTweets[0];
      ref.read(UserProfileProvider.notifier).set(UserProfile(
          id: tweet.user!.screenName,
          name: tweet.user!.name,
          imgUrl: tweet.user!.profileImageUrlHttps));
    }

    ref
        .read(TweetsState.notifier)
        .setNewTweets(ownTweets.map(constructTweetDateFromTweet).toList());

    onFinished();
  }

  _renderShowModal(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CreateTweetModal();
      },
    );
  }

  void onDeleteTweet(
      BuildContext context, WidgetRef ref, String tweetId) async {
    TwitterApi? client = await TwitterApiService().getClient();
    if (client == null) {
      return;
    }

    client.tweetService.destroy(id: tweetId);
    const snackBar = SnackBar(
        content: Text('ツイートを削除しました。'), backgroundColor: PrimaryTwitterBlue);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    var currentTweets = ref.read(TweetsState.notifier).state;
    ref.read(TweetsState.notifier).setNewTweets(
        currentTweets.where((element) => element.id != tweetId).toList());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<TweetData> tweets = ref.watch(TweetsState);
    final UserProfile? userProfile = ref.watch(UserProfileProvider);

    final loadedTweets = useState(false);

    useEffect(() {
      _fetchOwnTweets(ref, () {
        loadedTweets.value = true;
      });
    }, const []);

    if (!loadedTweets.value) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("home"),
          ),
          backgroundColor: Colors.white,
          body: ListView.separated(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return const TweetSkeleton();
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                    color: BorderColor,
                  )));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("home"),
      ),
      body: Center(
          child: tweets.isEmpty
              ? const Text(
                  "You have not tweeted anything. Let's Tweet!!",
                  style: title,
                )
              : ListView.separated(
                  itemCount: tweets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TweetContent(
                      tweet: tweets[index],
                      userProfile: userProfile ??
                          UserProfile(id: "", name: "", imgUrl: "imgUrl"),
                      onDelete: (String tweetId) {
                        onDeleteTweet(context, ref, tweetId);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        color: BorderColor,
                      ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _renderShowModal(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
          child: Button(
              onPressed: () {
                // Delete Twitter Auth Token
                const storage = FlutterSecureStorage();
                storage.deleteAll();

                Navigator.pushNamed(context, "/");
              },
              text: "ログアウト") // Populate the Drawer in the next step.
          ),
      backgroundColor: Colors.white,
    );
  }
}
