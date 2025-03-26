import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class JoinCompanyViaQrCode extends StatelessWidget {
   JoinCompanyViaQrCode({super.key});
  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryBorderButton(
            buttonText: 'join_company_via_qr_code'.tr.toUpperCase(),
            onPressed: () {
              controller.openQrCodeScanner();
            },
            textColor: defaultAccentColor,
            borderColor: defaultAccentColor),
      ),
    );
  }
}
