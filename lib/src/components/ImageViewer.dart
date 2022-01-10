import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

const double DEFAULT_ASPECT_RATIO_MEDIA_CONTAINER = 4 / 2.0;
const double AXIS_SPACING = 2.0;

class ImageViewer extends StatelessWidget {
  const ImageViewer({required this.imageUrls, Key? key}) : super(key: key);

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 4) {
      return FourPhotos(context, imageUrls);
    }
    if (imageUrls.length == 3) {
      return ThreePhotos(context, imageUrls);
    }
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
          const Gap(AXIS_SPACING),
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

Widget ThreePhotos(BuildContext context, List<String> imageUrls) {
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
          const Gap(AXIS_SPACING),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: CachedNetworkImageProvider(imageUrls[1]),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                const Gap(AXIS_SPACING),
                Expanded(
                  child: Image(
                    image: CachedNetworkImageProvider(imageUrls[2]),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
    borderRadius: BorderRadius.circular(12),
  );
}

Widget FourPhotos(BuildContext context, List<String> imageUrls) {
  return ClipRRect(
    child: AspectRatio(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: DEFAULT_ASPECT_RATIO_MEDIA_CONTAINER,
          crossAxisSpacing: AXIS_SPACING,
          mainAxisSpacing: AXIS_SPACING,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Image(
            image: CachedNetworkImageProvider(imageUrls[index]),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          );
        },
      ),
      aspectRatio: DEFAULT_ASPECT_RATIO_MEDIA_CONTAINER,
    ),
    borderRadius: BorderRadius.circular(12),
  );
}
