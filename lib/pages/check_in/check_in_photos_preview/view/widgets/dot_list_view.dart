import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../image_preview/controller/image_preview_controller.dart';

class DotIndicator extends StatelessWidget {
  // final int count;
  // final int currentIndex;

  final controller = Get.put(ImagePreviewController());

  // DotIndicator(
  //    {super.key, required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(controller.filesList.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: controller.currentIndex == index ? 8 : 6,
              height: controller.currentIndex == index ? 8 : 6,
              decoration: BoxDecoration(
                color: controller.currentIndex == index
                    ? Colors.blue
                    : Colors.grey,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ),
    );
  }
}
