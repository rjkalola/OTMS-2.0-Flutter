import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:belcka/pages/company/company_details/controller/company_details_controller.dart';
import 'package:belcka/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:belcka/pages/teams/sub_contractor_details/controller/sub_contractor_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';

class CompanyLogo extends StatelessWidget {
  CompanyLogo({super.key});

  final controller = Get.put(SubContractorDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 120,
            height: 120,
            alignment: Alignment.centerLeft,
            margin:
                const EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 20),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: dividerColor_(context)),
              shape: BoxShape.circle,
            ),
            child: ImageUtils.setCircularNetworkImage(
                url: controller.subContractorInfo.value.companyThumbImage ?? "",
                width: 100,
                height: 100,
                fit: BoxFit.fill,
                borderRadius: 45),
          ),
        ),
      ),
    );
  }
}
