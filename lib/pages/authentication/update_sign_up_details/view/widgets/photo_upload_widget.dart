import 'package:belcka/pages/authentication/update_sign_up_details/controller/update_sign_up_details_controller.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoUploadWidget extends StatelessWidget {
  PhotoUploadWidget({super.key});

  final controller = Get.put(UpdateSignUpDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: GestureDetector(
          onTap: () {
            controller.showAttachmentOptionsDialog();
          },
          child: !StringHelper.isEmptyString(controller.imagePath.value)
              ? (controller.imagePath.value.startsWith("http")
                  ? ImageUtils.setCircularNetworkImage(
                      url: controller.imagePath.value,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover)
                  : ImageUtils.setCircularFileImage(
                      controller.imagePath.value, 100, 100, BoxFit.cover))
              : ImageUtils.setAssetsImage(
                  path: Drawable.imgAddUserImage, width: 100, height: 100),
        ),
      ),
    );
  }
}
