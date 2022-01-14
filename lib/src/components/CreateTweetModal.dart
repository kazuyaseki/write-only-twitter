import 'dart:io';
import 'dart:typed_data';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:gap/gap.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/photofilters.dart';
import 'package:write_only_twitter/src/components/Button.dart';
import 'package:write_only_twitter/src/globalStates/TweetsState.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';
import 'package:write_only_twitter/src/service/twitter_api_service.dart';
import 'package:write_only_twitter/src/theme/colors.dart';
import 'package:write_only_twitter/src/theme/typography.dart';

class CreateTweetModal extends HookConsumerWidget {
  CreateTweetModal({
    Key? key,
  }) : super(key: key);

  final List<Filter> filters = presetFiltersList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetText = useState("");
    final imageFile = useState<XFile?>(null);

    Future getImage(context) async {
      try {
        final ImagePicker _picker = ImagePicker();
        imageFile.value = await _picker.pickImage(source: ImageSource.gallery);
      } on PlatformException catch (e) {
        print(e);
      }

      if (imageFile == null) {
        return;
      }

      String fileName = basename(imageFile.value!.path);
      Uint8List imageBytes = await imageFile.value!.readAsBytes();
      var image = imageLib.decodeImage(imageBytes);
      image = imageLib.copyResize(image!, width: 600);

      Map imagefile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoFilterSelector(
            title: const Text("Photo Filter Example"),
            image: image!,
            filters: presetFiltersList,
            filename: fileName,
            loader: const Center(child: CircularProgressIndicator()),
            fit: BoxFit.contain,
          ),
        ),
      );
      if (imagefile != null && imagefile.containsKey('image_filtered')) {
        imageFile.value = imagefile['image_filtered'];
      }
    }

    sendTweet() async {
      TwitterApi? client = await TwitterApiService().getClient();
      if (client == null) {
        return;
      }

      try {
        Tweet postedTweet =
            await client.tweetService.update(status: tweetText.value);
        const snackBar = SnackBar(
            content: Text('ツイートを送信しました。'), backgroundColor: PrimaryTwitterBlue);

        ref.read(TweetsState.notifier).postTweet(TweetData(
            id: postedTweet.idStr, text: postedTweet.fullText, imgUrls: []));

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        print(e);
        const snackBar = SnackBar(
          content: Text('ツイートの送信に失敗しました'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // twitterApi.mediaService.uploadInit(totalBytes: 1000, mediaType: "");
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: [
          const SafeArea(
            child: SizedBox.shrink(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 40,
                  icon: const Icon(
                    Icons.chevron_left,
                    color: IconColor,
                    semanticLabel: 'cancel tweeting',
                  )),
              Button(
                  onPressed: () {
                    sendTweet();
                  },
                  text: "ツイートする")
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    minLines: 6,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    decoration: const InputDecoration.collapsed(
                        hintText: 'いまどうしてる？', hintStyle: hintText),
                    onChanged: (text) {
                      tweetText.value = text;
                    },
                  ),
                  const Divider(
                    color: BorderColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            getImage(context);
                          },
                          iconSize: 24,
                          icon: const Icon(
                            Icons.image_outlined,
                            color: PrimaryTwitterBlue,
                            semanticLabel: 'Add Images',
                          )),
                      const Gap(4),
                      const Icon(
                        Icons.gif,
                        color: PrimaryTwitterBlue,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      const Gap(20),
                      const Icon(
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
