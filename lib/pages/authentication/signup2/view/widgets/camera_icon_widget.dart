import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup2/controller/signup2_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';

class CameraIconWidget extends StatelessWidget {
  CameraIconWidget({super.key});

  final controller = Get.put(SignUp2Controller());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          controller.showAttachmentOptionsDialog();
        },
        child: !StringHelper.isEmptyString(controller.imagePath.value)
            ? ImageUtils.setCircularFileImage(
                controller.imagePath.value, 150, 150, BoxFit.cover)
            : ImageUtils.setSvgAssetsImage(
                path: Drawable.cameraPlaceHolder, width: 150, height: 150),
      ),
    );
  }
}
