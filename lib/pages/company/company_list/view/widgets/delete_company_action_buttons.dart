import 'package:belcka/pages/company/company_list/controller/company_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteCompanyActionButtons extends StatelessWidget {
  DeleteCompanyActionButtons({super.key});

  final controller = Get.put(CompanyListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isDeleteEnable.value,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: PrimaryButton(
                    buttonText: 'delete'.tr,
                    onPressed: () {

                    },
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  flex: 1,
                  child: PrimaryBorderButton(
                      buttonText: 'cancel'.tr,
                      borderColor: secondaryLightTextColor_(context),
                      fontColor: secondaryLightTextColor_(context),
                      onPressed: () {
                        // controller.unCheckAll();
                        controller.isDeleteEnable.value = false;
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
