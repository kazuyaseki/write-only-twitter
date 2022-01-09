import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';
import 'package:write_only_twitter/src/theme/colors.dart';
import 'package:write_only_twitter/src/theme/typography.dart';

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
      Gap(12),
      Flexible(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
        Row(children: [Text("seya", style: title,), SizedBox(width: 4,), Text("@sekikazu01", style: subtitle,)],),
        Gap(4),
        Text(tweet.text, textAlign: TextAlign.left, style: body,),
        Gap(12),
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Icon(
            Icons.mode_comment_outlined,
            color: IconColor,
            size: 20.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),Icon(
            Icons.share,
            color: IconColor,
            size: 20.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),Icon(
            Icons.delete_outline,
            color: IconColor,
            size: 20.0,
            semanticLabel: 'Text to announce in accessibility modes',
          )],)
        
      ],))
      
    ]));
  }
}
