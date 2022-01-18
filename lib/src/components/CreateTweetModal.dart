import 'dart:io';
import 'dart:typed_data';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:gap/gap.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/photofilters.dart';
import 'package:write_only_twitter/src/components/Button.dart';
import 'package:write_only_twitter/src/components/ImagesCarousel.dart';
import 'package:write_only_twitter/src/globalStates/TweetsState.dart';
import 'package:write_only_twitter/src/misc/list_utils.dart';
import 'package:write_only_twitter/src/models/Tweet.dart';
import 'package:write_only_twitter/src/service/twitter_api_service.dart';
import 'package:write_only_twitter/src/theme/colors.dart';
import 'package:write_only_twitter/src/theme/typography.dart';
import 'package:path_provider/path_provider.dart';

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getApplicationDocumentsDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

const _maxChunkSize = 500000;

class CreateTweetModal extends HookConsumerWidget {
  CreateTweetModal({
    Key? key,
  }) : super(key: key);

  final List<Filter> filters = presetFiltersList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetText = useState("");
    final imageFiles = useState<List<XFile>>([]);

    useEffect(() {
      loadBundles() async {
        final File f = await getImageFileFromAssets('test.png');
        final File f2 = await getImageFileFromAssets('test2.png');
        // final File f3 = await getImageFileFromAssets('test3.png');
        // imageFiles.value = [XFile(f2.path), XFile(f.path), XFile(f3.path)];
        imageFiles.value = [XFile(f2.path), XFile(f.path)];
      }

      loadBundles();
    }, []);

    Future getImage(context) async {
      try {
        final ImagePicker _picker = ImagePicker();
        var _imageFiles = await _picker.pickMultiImage();

        if (_imageFiles != null) {
          imageFiles.value = _imageFiles;
        }
      } on PlatformException catch (e) {
        print(e);
      }
    }

    void editImage(int index) async {
      var file = imageFiles.value[index];

      String fileName = basename(file.path);
      Uint8List imageBytes = await file.readAsBytes();
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
        var copy = [...imageFiles.value];
        copy[index] = imagefile['image_filtered'];
        imageFiles.value = copy;
      }
    }

    /// Concurrently requests the status of an upload until the uploaded
    /// succeeded and waits the suggested time between each call.
    ///
    /// Returns `null` if the upload failed.
    Future<UploadStatus?> _waitForUploadCompletion({
      required TwitterApi client,
      required String mediaId,
      required int sleep,
    }) async {
      await Future<void>.delayed(Duration(seconds: sleep));

      final uploadStatus = await client.mediaService.uploadStatus(
        mediaId: mediaId,
      );

      if (uploadStatus.processingInfo != null &&
          uploadStatus.processingInfo!.succeeded) {
        // upload processing has succeeded
        return uploadStatus;
      } else if (uploadStatus.processingInfo != null &&
          uploadStatus.processingInfo!.inProgress) {
        // upload is still processing, need to wait longer
        return _waitForUploadCompletion(
          client: client,
          mediaId: mediaId,
          sleep: uploadStatus.processingInfo!.checkAfterSecs!,
        );
      } else {
        return null;
      }
    }

    void sendTweet() async {
      TwitterApi? client = await TwitterApiService().getClient();
      if (client == null) {
        return;
      }

      List<String> mediaIds = [];

      try {
        if (imageFiles.value.isNotEmpty) {
          for (var file in imageFiles.value) {
            final bytes = await file.readAsBytes();
            final totalBytes = bytes.length;
            final mediaType = mime(file.path);

            if (totalBytes == 0 || mediaType == null) {
              // unknown type or empty file
              break;
            }
            final uploadInit = await client.mediaService
                .uploadInit(totalBytes: totalBytes, mediaType: mediaType);

            final mediaId = uploadInit.mediaIdString!;

            final mediaChunks = splitList(
              bytes,
              _maxChunkSize,
            );

            for (var i = 0; i < mediaChunks.length; i++) {
              final chunk = mediaChunks[i];

              await client.mediaService.uploadAppend(
                mediaId: mediaId,
                media: chunk,
                segmentIndex: i,
              );
            }

            final uploadFinalize = await client.mediaService.uploadFinalize(
              mediaId: mediaId,
            );

            if (uploadFinalize.processingInfo?.pending ?? false) {
              // asynchronous upload of media
              // we have to wait until twitter has processed the upload
              final finishedStatus = await _waitForUploadCompletion(
                client: client,
                mediaId: mediaId,
                sleep: uploadFinalize.processingInfo!.checkAfterSecs!,
              );

              print(finishedStatus?.mediaIdString);
            }

            mediaIds.add(uploadFinalize.mediaIdString!);
          }
        }

        Tweet postedTweet = await client.tweetService
            .update(status: tweetText.value, mediaIds: mediaIds);
        const snackBar = SnackBar(
            content: Text('ツイートを送信しました。'), backgroundColor: PrimaryTwitterBlue);

        ref
            .read(TweetsState.notifier)
            .postTweet(constructTweetDateFromTweet(postedTweet));

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        print(e);
        const snackBar = SnackBar(
          content: Text('ツイートの送信に失敗しました'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFFFFFFFF),
        child: Stack(
          children: [
            Column(
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
                        // with multibyte chars 140 chars
                        // URL is counted as 23 chars
                        // FIXME: add count logic for chars
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
                        const Gap(12),
                        ImagesCarousel(
                            images: imageFiles.value,
                            onRemoveImage: (int index) {
                              List<XFile> copy = [...imageFiles.value];
                              copy.removeAt(index);
                              imageFiles.value = copy;
                            },
                            onEditImage: editImage)
                      ],
                    )),
              ],
            ),
            Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Divider(color: BorderColor, height: 1),
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
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }
}
