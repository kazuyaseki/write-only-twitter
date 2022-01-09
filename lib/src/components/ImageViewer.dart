import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({required this.imageUrls, Key? key}) : super(key: key);

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 2) {
      return TwoPhotos(context, imageUrls);
    }
    if (imageUrls.length == 1) {
      return SinglePhoto(imageUrls[0]);
    }

    return const SizedBox.shrink();
  }
}

Widget SinglePhoto(String imageUrl) {
  return ClipRRect(
    child: Image.network(imageUrl),
    borderRadius: BorderRadius.circular(12),
  );
}

Widget TwoPhotos(BuildContext context, List<String> imageUrls) {
  const double DEFAULT_ASPECT_RATIO_MEDIA_CONTAINER = 5.0 / 2.0;

  return ClipRRect(
    child: AspectRatio(
      aspectRatio: DEFAULT_ASPECT_RATIO_MEDIA_CONTAINER,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Image(
              image: CachedNetworkImageProvider(imageUrls[0]),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(2),
          Expanded(
            child: Image(
              image: CachedNetworkImageProvider(imageUrls[1]),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    ),
    borderRadius: BorderRadius.circular(12),
  );
}
