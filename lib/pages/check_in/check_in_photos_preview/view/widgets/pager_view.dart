import 'package:belcka/pages/check_in/check_in_photos_preview/controller/check_in_photos_preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:belcka/pages/image_preview/controller/image_preview_controller.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:get/get.dart';

class PagerView extends StatelessWidget {
  PagerView({super.key});

  final controller = Get.put(CheckInPhotosPreviewController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: PhotoViewGallery.builder(
          itemCount: controller.filesList.length,
          pageController: controller.pageController.value,
          onPageChanged: (index) {
            controller.currentIndex.value = index;
            print("controller.currentIndex.value:" +
                controller.currentIndex.value.toString());
          },
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: ImageUtils.imageProvider(
                  controller.filesList[index].imageUrl ?? ""),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.5,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: controller.filesList[index]),
            );
          },
          backgroundDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
