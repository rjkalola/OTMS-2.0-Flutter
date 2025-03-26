import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class UploadPhotoView extends StatelessWidget {
  UploadPhotoView({super.key});

  final controller = Get.put(CompanySignUpController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 240,
          height: 100,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 16, top: 20, right: 16),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: dividerColor),
              borderRadius: BorderRadius.all(Radius.circular(
                      3.0) //                 <--- border radius here
                  )),
          child: !StringHelper.isEmptyString(controller.mCompanyLogo.value)
              ? controller.mCompanyLogo.value.startsWith("http")
                  ? ImageUtils.setNetworkImage(controller.mCompanyLogo.value,
                      double.infinity, double.infinity, BoxFit.fill)
                  : ImageUtils.setFileImage(controller.mCompanyLogo.value,
                      double.infinity, double.infinity, BoxFit.fill)
              : Container(
                  color: dividerColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('upload_photo'.tr,
                            style: TextStyle(
                                fontSize: 16,
                                color: primaryTextColor,
                                fontWeight: FontWeight.w300)),
                        Text('600 * 250',
                            style: TextStyle(
                                fontSize: 15,
                                color: primaryTextColor,
                                fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                ),
        )
      ],
    );
  }
}
