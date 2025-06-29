import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class JoinCompanyButton extends StatelessWidget {
  JoinCompanyButton({super.key});

  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
            buttonText: 'join_a_company'.tr,
            onPressed: () {
              if (!controller.isOtpViewVisible.value &&
                  !controller.isSelectTradeVisible.value) {
                controller.isOtpViewVisible.value = true;
              }
              // controller.openQrCodeScanner();
            }),
      ),
    );
  }
}
