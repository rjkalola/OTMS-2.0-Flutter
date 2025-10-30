import 'package:belcka/widgets/image/document_view.dart';
import 'package:flutter/material.dart';
import 'package:belcka/pages/image_preview/controller/image_preview_controller.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:get/get.dart';

class PagerView extends StatelessWidget {
  PagerView({super.key});

  final controller = Get.put(ImagePreviewController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: PhotoViewGallery.builder(
          itemCount: controller.filesList.length,
          pageController: controller.pageController.value,
          onPageChanged: (index) {
            controller.currentIndex.value = index;
          },
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (context, index) {
            final fileUrl = controller.filesList[index].imageUrl ?? "";
            final type = ImageUtils.getFileType(fileUrl);

            // 🖼️ If it's an image → show zoomable view
            if (type == 'image') {
              return PhotoViewGalleryPageOptions(
                imageProvider: ImageUtils.imageProvider(fileUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.5,
                heroAttributes: PhotoViewHeroAttributes(tag: fileUrl),
              );
            }

            // 📄 Otherwise → show a static document preview
            return PhotoViewGalleryPageOptions.customChild(
              disableGestures: true,
              child: PhotoViewGestureDetectorScope(
                axis: Axis.vertical, // or Axis.all to allow all gestures
                child: InkWell(
                  onTap: () async {
                    await ImageUtils.openAttachment(context, fileUrl, type);
                  },
                  child: DocumentView(
                    onRemoveClick: () {},
                    isEditable: false,
                    file: fileUrl,
                    fileRadius: 0,
                    documentIconSize: 46,
                  ),
                ),
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(tag: fileUrl),
            );

            /* final type = ImageUtils.getFileType(controller.filesList[index].imageUrl ?? "");
            return PhotoViewGalleryPageOptions(
              imageProvider: ImageUtils.imageProvider(
                  controller.filesList[index].imageUrl ?? ""),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.5,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: controller.filesList[index]),
            );*/
          },
          backgroundDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
