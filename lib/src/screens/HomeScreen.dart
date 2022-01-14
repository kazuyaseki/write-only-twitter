import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:write_only_twitter/src/components/Button.dart';
import 'package:write_only_twitter/src/components/CreateTweetModal.dart';
import 'package:write_only_twitter/src/components/TweetContent.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';
import 'package:write_only_twitter/src/models/UserProfile.dart';
import 'package:write_only_twitter/src/service/twitter_api_service.dart';
import 'package:write_only_twitter/src/service/twitter_auth_token_service.dart';
import 'package:write_only_twitter/src/theme/colors.dart';
import 'package:write_only_twitter/src/theme/typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(milliseconds: 200), _renderShowModal);

    _fetchOwnTweets();
  }

  List<TweetData> tweets = [];
  UserProfile? userProfile;

  _fetchOwnTweets() async {
    TwitterApi? client = await TwitterApiService().getClient();
    if (client == null) {
      return;
    }

    final userId = await TwitterAuthTokenService().getTwitterUserId();

    final ownTweets =
        await client.timelineService.userTimeline(userId: userId, count: 10);

    if (ownTweets.isNotEmpty) {
      Tweet tweet = ownTweets[0];
      setState(() {
        userProfile = UserProfile(
            id: tweet.user!.screenName,
            name: tweet.user!.name,
            imgUrl: tweet.user!.profileImageUrlHttps);
      });
    }

    setState(() {
      tweets = ownTweets
          .map((tweetData) => TweetData(
              id: tweetData.idStr, text: tweetData.fullText, imgUrls: []))
          .toList();
    });
  }

  _renderShowModal() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CreateTweetModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
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
                            UserProfile(id: "", name: "", imgUrl: "imgUrl"));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        color: BorderColor,
                      ))),
      floatingActionButton: FloatingActionButton(
        onPressed: _renderShowModal,
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
