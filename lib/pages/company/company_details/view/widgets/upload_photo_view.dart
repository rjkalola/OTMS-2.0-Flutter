import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:belcka/pages/company/company_details/controller/company_details_controller.dart';
import 'package:belcka/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';

class UploadPhotoView extends StatelessWidget {
  UploadPhotoView({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: GestureDetector(
          onTap: () {
            controller.onSelectCompanyLogo();
          },
          child: Container(
            width: 120,
            height: 120,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 16, top: 4, right: 16),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: dividerColor_(context)),
              shape: BoxShape.circle,
            ),
            child: !StringHelper.isEmptyString(controller.mCompanyLogo.value)
                ? (controller.mCompanyLogo.value.startsWith("http")
                    ? ImageUtils.setCircularNetworkImage(
                        url: controller.mCompanyLogo.value,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill)
                    : ImageUtils.setCircularFileImage(
                        controller.mCompanyLogo.value, 100, 100, BoxFit.fill))
                : Center(
                    child: ImageUtils.setAssetsImage(
                        path: Drawable.imgAddImage, width: 120, height: 50),
                  ),
          ),
        ),
      ),
    );
  }
}
