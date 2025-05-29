import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class UploadPhotoView extends StatelessWidget {
  UploadPhotoView({super.key});

  final controller = Get.put(CompanySignUpController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: GestureDetector(
          onTap: () {
            controller.onSelectCompanyLogo();
          },
          child: Container(
            width: 240,
            height: 100,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 16, top: 4, right: 16),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(color: dividerColor),
                borderRadius: BorderRadius.all(Radius.circular(
                        3.0) //                 <--- border radius here
                    )),
            child: !StringHelper.isEmptyString(controller.mCompanyLogo.value)
                ? (controller.mCompanyLogo.value.startsWith("http")
                    ? ImageUtils.setNetworkImage(controller.mCompanyLogo.value,
                        double.infinity, double.infinity, BoxFit.fill)
                    : ImageUtils.setFileImage(controller.mCompanyLogo.value,
                        double.infinity, double.infinity, BoxFit.fill))
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
