import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';
import 'package:path/path.dart';
import 'package:gap/gap.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/photofilters.dart';
import 'package:write_only_twitter/src/components/Button.dart';
import 'package:write_only_twitter/src/theme/colors.dart';
import 'package:write_only_twitter/src/theme/typography.dart';

class CreateTweetModal extends StatefulWidget {
  @override
  _CreateTweetModalState createState() => new _CreateTweetModalState();
}

class _CreateTweetModalState extends State<CreateTweetModal> {
  String fileName = "";
  List<Filter> filters = presetFiltersList;
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    Future getImage(context) async {
      try {
        print("hoge");
        final ImagePicker _picker = ImagePicker();
        imageFile = await _picker.pickImage(source: ImageSource.gallery);
        print(imageFile);
      } on PlatformException catch (e) {
        print(e);
      }
      print(imageFile?.name);

      if (imageFile == null) {
        return;
      }

      fileName = basename(imageFile!.path);
      Uint8List imageBytes = await imageFile!.readAsBytes();
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
        setState(() {
          imageFile = imagefile['image_filtered'];
        });
        print(imageFile!.path);
      }
    }

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
