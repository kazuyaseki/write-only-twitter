import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImagesCarousel extends HookConsumerWidget {
  const ImagesCarousel({
    required this.images,
    Key? key,
  }) : super(key: key);

  final List<XFile> images;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    if (images.length == 1) {
      return Stack(
        children: [Image.file(File(images[0].path))],
      );
    }
    return Row(
      children: [Image.file(File(images[0].path))],
    );
  }
}
