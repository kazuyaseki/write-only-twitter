import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:write_only_twitter/src/components/Button.dart';
import 'package:write_only_twitter/src/theme/colors.dart';
import 'package:write_only_twitter/src/theme/typography.dart';

class CreateTweetModal extends StatelessWidget {
  const CreateTweetModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.chevron_left,
                color: IconColor,
                size: 40.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Button(
                  onPressed: () {
                    print("ツイートを送信しました");
                  },
                  text: "ツイートする")
            ],
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const TextField(
                    minLines: 6,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration.collapsed(
                        hintText: 'いまどうしてる？', hintStyle: hintText),
                  ),
                  const Divider(
                    color: BorderColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.image_outlined,
                        color: PrimaryTwitterBlue,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      Gap(20),
                      Icon(
                        Icons.gif,
                        color: PrimaryTwitterBlue,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      Gap(20),
                      Icon(
                        Icons.poll_outlined,
                        color: PrimaryTwitterBlue,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
