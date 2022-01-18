import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

const double DEFAULT_ASPECT_RATIO_MEDIA_CONTAINER = 4 / 2.0;

class ImagesCarousel extends HookConsumerWidget {
  const ImagesCarousel({
    required this.images,
    required this.onRemoveImage,
    required this.onEditImage,
    Key? key,
  }) : super(key: key);

  final List<XFile> images;
  final void Function(int index) onRemoveImage;
  final void Function(int index) onEditImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    if (images.length == 1) {
      return Stack(
        children: [
          ClipRRect(
            child: Image.file(
              File(images[0].path),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          Positioned(
            right: 2.0,
            top: 10.0,
            child: CloseButton(() {
              onRemoveImage(0);
            }),
          ),
          Positioned(
            right: 2.0,
            bottom: 10.0,
            child: CloseButton(() {
              onEditImage(0);
            }),
          )
        ],
      );
    }

    return CarouselSlider(
        options: CarouselOptions(
            height: 204.0,
            viewportFraction: 0.60,
            enableInfiniteScroll: false,
            enlargeStrategy: CenterPageEnlargeStrategy.scale),
        items: images.map((image) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(children: [
                ClipRRect(
                  child: Image.file(
                    File(image.path),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                Positioned(
                  right: 2.0,
                  top: 10.0,
                  child: CloseButton(() {
                    onRemoveImage(0);
                  }),
                ),
                Positioned(
                  right: 2.0,
                  bottom: 10.0,
                  child: CloseButton(() {
                    onEditImage(0);
                  }),
                )
              ]);
            },
          );
        }).toList());
  }
}

Widget CloseButton(void Function() onRemoveImage) {
  return ElevatedButton(
    child: const Icon(
      Icons.close,
      color: Colors.white,
      semanticLabel: 'remove image',
    ),
    style: ElevatedButton.styleFrom(
      primary: const Color(0x88000000),
      shape: const CircleBorder(
        side: BorderSide(
          color: Color(0x88000000),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
    ),
    onPressed: onRemoveImage,
  );
}

Widget EditButton(void Function() onEditImage) {
  return ElevatedButton(
    child: const Icon(
      Icons.brush_outlined,
      color: Colors.white,
      semanticLabel: 'remove image',
    ),
    style: ElevatedButton.styleFrom(
      primary: const Color(0x88000000),
      shape: const CircleBorder(
        side: BorderSide(
          color: Color(0x88000000),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
    ),
    onPressed: onEditImage,
  );
}
