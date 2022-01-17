import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:write_only_twitter/src/components/ImageViewer.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';
import 'package:write_only_twitter/src/models/UserProfile.dart';
import 'package:write_only_twitter/src/theme/colors.dart';
import 'package:write_only_twitter/src/theme/typography.dart';

class TweetContent extends HookConsumerWidget {
  const TweetContent({required this.tweet, required this.userProfile, Key? key})
      : super(key: key);

  final UserProfile userProfile;
  final TweetData tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        color: Colors.white,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                userProfile.imgUrl ??
                    "https://abs.twimg.com/sticky/default_profile_images/default_profile_400x400.png",
                width: 42,
                height: 42,
              ),
              const Gap(12),
              Flexible(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userProfile.name ?? "",
                        style: title,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "@${userProfile.id ?? ""}",
                        style: subtitle,
                      )
                    ],
                  ),
                  const Gap(2),
                  Text(
                    tweet.text ?? "",
                    textAlign: TextAlign.left,
                    style: body,
                  ),
                  const Gap(12),
                  ImageViewer(imageUrls: tweet.imgUrls),
                  tweet.imgUrls.isNotEmpty
                      ? const Gap(12)
                      : const SizedBox.shrink(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Share.share(
                                'check out my website https://example.com');
                          },
                          iconSize: 20,
                          icon: const Icon(
                            Icons.mode_comment_outlined,
                            color: IconColor,
                            semanticLabel: 'add reply',
                          )),
                      IconButton(
                          onPressed: () {
                            Share.share(
                                "https://twitter.com/${userProfile.id}/status/${tweet.id}");
                          },
                          iconSize: 20,
                          icon: const Icon(
                            Icons.share,
                            color: IconColor,
                            semanticLabel: 'share tweet',
                          )),
                      IconButton(
                          onPressed: () {
                            Share.share(
                                'check out my website https://example.com');
                          },
                          iconSize: 20,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: IconColor,
                            semanticLabel: 'delete tweet',
                          )),
                    ],
                  )
                ],
              ))
            ]));
  }
}
