import 'package:flutter/material.dart';
import 'package:write_only_twitter/src/components/Button.dart';
import 'package:write_only_twitter/src/components/TweetContent.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<Tweet> dummyTweets = [
  Tweet(
      id: "1480103849495261193",
      text:
          "先日全て削除したことで話題になった faker.js の作者が、 colors.js というライブラリがインストールされる度にアメリカ国旗を console に出力する無限ループを含んだコードをリリースしたらしい https://www.reddit.com/r/programming/comments/rz5rul/marak_creator_of_fakerjs_who_recently_deleted_the/",
      imgUrls: []),
  Tweet(id: "1480132466912669700", text: "あまりにも辛い現実", imgUrls: [
    "https://pbs.twimg.com/media/FIp8ji7agAEtidl?format=jpg&name=large"
  ])
];

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: dummyTweets.map((tweet) {
              return TweetContent(tweet: tweet);
            }).toList()
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
