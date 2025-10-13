import 'dart:io' show File;

import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_controller.dart';
import 'package:belcka/pages/profile/my_profile_details/view/widgets/full_screen_image_view.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class ProfileAvatarWidget extends StatelessWidget {
   ProfileAvatarWidget({super.key});
  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageView(
              imageUrl: controller.myProfileInfo.value.userImage ?? "",
            ),
          ),
        );
        */

        if (controller.isComingFromMyProfile){
          if (!controller.isOtpViewVisible.value) {
            controller.showAttachmentOptionsDialog();
          }
        }
      },
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Rounded Square Border with Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: !StringHelper.isEmptyString(controller.imagePath.value) ? Image.file(
                  File(controller.imagePath.value ?? "")) : Image.network(
                  "${controller.myProfileInfo.value.userThumbImage}",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Status Indicator (bottom right)
            Positioned(
              bottom: 0,
              right: -5,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: controller.myProfileInfo.value.isWorking ?? false ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2, // White border for clarity
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}