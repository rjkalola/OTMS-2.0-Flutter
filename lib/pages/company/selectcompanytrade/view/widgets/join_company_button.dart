import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/controller/select_company_trade_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class JoinCompanyButton extends StatelessWidget {
  JoinCompanyButton({super.key});

  final controller = Get.put(SelectCompanyTradeController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryBorderButton(
            buttonText: 'join_company'.tr,
            onPressed: () {
              controller.onClickJoinCompany();
            },
            fontColor: defaultAccentColor,
            borderColor: defaultAccentColor),
      ),
    );
  }
}
