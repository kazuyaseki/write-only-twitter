import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:write_only_twitter/src/models/media_data.dart';

const double DEFAULT_ASPECT_RATIO_MEDIA_CONTAINER = 4 / 2.0;
const double AXIS_SPACING = 2.0;

class ImageViewer extends StatelessWidget {
  const ImageViewer({required this.images, Key? key}) : super(key: key);

  final List<ImageData> images;

  @override
  Widget build(BuildContext context) {
    if (images.length == 4) {
      return FourPhotos(context, images);
    }
    if (images.length == 3) {
      return ThreePhotos(context, images);
    }
    if (images.length == 2) {
      return TwoPhotos(context, images);
    }
    if (images.length == 1) {
      return SinglePhoto(images[0]);
    }

    return const SizedBox.shrink();
  }
}

Widget SinglePhoto(ImageData image) {
  return ClipRRect(
    child: Image.network(image.baseUrl),
    borderRadius: BorderRadius.circular(12),
  );
}

Widget TwoPhotos(BuildContext context, List<ImageData> images) {
  return ClipRRect(
    child: AspectRatio(
      aspectRatio: DEFAULT_ASPECT_RATIO_MEDIA_CONTAINER,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Image(
              image: CachedNetworkImageProvider(images[0].baseUrl),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(AXIS_SPACING),
          Expanded(
            child: Image(
              image: CachedNetworkImageProvider(images[1].baseUrl),
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

Widget ThreePhotos(BuildContext context, List<ImageData> images) {
  return ClipRRect(
    child: AspectRatio(
      aspectRatio: DEFAULT_ASPECT_RATIO_MEDIA_CONTAINER,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Image(
              image: CachedNetworkImageProvider(images[0].baseUrl),
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
                    image: CachedNetworkImageProvider(images[1].baseUrl),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                const Gap(AXIS_SPACING),
                Expanded(
                  child: Image(
                    image: CachedNetworkImageProvider(images[2].baseUrl),
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

Widget FourPhotos(BuildContext context, List<ImageData> images) {
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
            image: CachedNetworkImageProvider(images[index].baseUrl),
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
