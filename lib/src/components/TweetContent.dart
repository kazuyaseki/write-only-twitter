import 'package:flutter/material.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';

class TweetContent extends StatelessWidget {
  const TweetContent({required this.tweet, Key? key}) : super(key: key);

  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Image.network("https://pbs.twimg.com/profile_images/1475062555903393798/rhOyAqfu_400x400.jpg", width: 42, height: 42,),
      SizedBox(width: 12,),
      Flexible(child: Column(children: [
        Row(children: [Text("seya"), SizedBox(width: 4,), Text("@sekikazu01")],),
        SizedBox(height: 8,),
        Container(child: Text(tweet.text, softWrap: true,))
        
      ],))
      
    ]));
  }
}
