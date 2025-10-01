import 'package:belcka/pages/check_in/check_in_photos_preview/controller/check_in_photos_preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/image_preview/controller/image_preview_controller.dart';
import 'package:belcka/utils/image_utils.dart';

class HorizontalListView extends StatelessWidget {
  HorizontalListView({super.key});

  final controller = Get.put(CheckInPhotosPreviewController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.filesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => controller.onThumbnailTap(index),
            child: Obx(
              () => Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: index == controller.currentIndex.value
                          ? Colors.blueAccent
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: (controller.filesList[index].imageUrl ?? "")
                          .startsWith("http")
                      ? ImageUtils.setNetworkImage(
                          url: controller.filesList[index].imageUrl ?? "",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover)
                      : ImageUtils.setFileImage(
                          url: controller.filesList[index].imageUrl ?? "",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover)),
            ),
          );
        },
      ),
    );
  }
}
