import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeleton_text/skeleton_text.dart';

class TweetSkeleton extends StatelessWidget {
  const TweetSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SkeletonAnimation(
            child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(100)),
        )),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(2),
            SkeletonAnimation(
                child: Container(
              width: 160,
              height: 8,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2)),
            )),
            const Gap(8),
            SkeletonAnimation(
                child: Container(
              width: MediaQuery.of(context).size.width - 108,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2)),
            )),
          ],
        )
      ]),
    );
  }
}
