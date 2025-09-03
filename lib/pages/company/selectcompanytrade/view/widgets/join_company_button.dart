import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/selectcompanytrade/controller/select_company_trade_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

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
            fontColor: defaultAccentColor_(context),
            borderColor: defaultAccentColor_(context)),
      ),
    );
  }
}
