import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:write_only_twitter/src/components/Button.dart';
import 'package:write_only_twitter/src/components/CreateTweetModal.dart';
import 'package:write_only_twitter/src/components/TweetContent.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';
import 'package:write_only_twitter/src/theme/colors.dart';
import 'package:write_only_twitter/src/theme/typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<TweetData> dummyTweets = [
  TweetData(id: "1479733228085063680", text: "カービィカフェわず", imgUrls: [
    "https://pbs.twimg.com/media/FIkRY-5aMAAkyHt?format=jpg&name=large",
    "https://pbs.twimg.com/media/FIkRY_oaUAEfyB1?format=jpg&name=large",
    "https://pbs.twimg.com/media/FIkRY_kaMAAn36z?format=jpg&name=large",
    "https://pbs.twimg.com/media/FIkRcaJaQAANlzz?format=jpg&name=large"
  ]),
  TweetData(id: "1459307956176969730", text: "受付してくれる猫", imgUrls: [
    "https://pbs.twimg.com/media/FECA1qlacAAm9q2?format=jpg&name=large",
    "https://pbs.twimg.com/media/FECA1qmaMAAzXuO?format=jpg&name=large",
    "https://pbs.twimg.com/media/FECA1rwaAAA0FUx?format=jpg&name=large",
  ]),
  TweetData(id: "1479791942196404227", text: "立ち食い梅干し食べ比べしてきました", imgUrls: [
    "https://pbs.twimg.com/media/FIlGzVdagAEmrKd?format=jpg&name=large",
    "https://pbs.twimg.com/media/FIlGzV0aUAEaXKe?format=jpg&name=large"
  ]),
  TweetData(
      id: "1480103849495261193",
      text:
          "先日全て削除したことで話題になった faker.js の作者が、 colors.js というライブラリがインストールされる度にアメリカ国旗を console に出力する無限ループを含んだコードをリリースしたらしい https://www.reddit.com/r/programming/comments/rz5rul/marak_creator_of_fakerjs_who_recently_deleted_the/",
      imgUrls: []),
  TweetData(id: "1480132466912669700", text: "あまりにも辛い現実", imgUrls: [
    "https://pbs.twimg.com/media/FIp8ji7agAEtidl?format=jpg&name=large"
  ])
];

class RedeemConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(
          0.85), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(milliseconds: 200), _renderShowModal);

    print("initstate");
    _fetchOwnTweets();
  }

  List<TweetData> tweets = [];

  _fetchOwnTweets() async {
    final key = dotenv.env['TWITTER_API_CONSUMER_KEY']!;
    final secret = dotenv.env['TWITTER_API_CONSUMER_KEY_SECRET']!;

    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "TWITTER_USER_TOKEN");
    String? tokenSecret = await storage.read(key: "TWITTER_USER_TOKEN_SECRET");

    if (token == null || tokenSecret == null) {
      return;
    }

    TwitterApi twitterApi = TwitterApi(
      client: TwitterClient(
        consumerKey: key,
        consumerSecret: secret,
        token: token,
        secret: tokenSecret,
      ),
    );

    final userId = await storage.read(key: "TWITTER_USER_ID");

    final ownTweets = await twitterApi.timelineService
        .userTimeline(userId: userId, count: 10);

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
          child: tweets.length == 0
              ? const Text(
                  "You have not tweeted anything. Let's Tweet!!",
                  style: title,
                )
              : ListView.separated(
                  itemCount: tweets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TweetContent(tweet: tweets[index]);
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
