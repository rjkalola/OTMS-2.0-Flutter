import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/select_before_after_photos/controller/select_before_after_photos_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';

class SubmitBtnBeforeAfterPhotos extends StatelessWidget {
  SubmitBtnBeforeAfterPhotos({super.key});

  final controller = Get.put(SelectBeforeAfterPhotosController());

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.isEditable.value,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: PrimaryBorderButton(
              buttonText: 'submit'.tr,
              onPressed: () {
                controller.onSubmitClick();
              },
              fontColor: defaultAccentColor_(context),
              borderColor: defaultAccentColor_(context)),
        ),
      ),
    );
  }
}
