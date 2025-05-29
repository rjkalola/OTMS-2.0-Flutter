import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/controller/select_company_trade_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class CompanyNoteText extends StatelessWidget {
  CompanyNoteText({super.key});

  final controller = Get.put(SelectCompanyTradeController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: PrimaryTextView(
          text:
              "You're Registering your account with ${controller.companyDetails.value.companyName}, Please select the trade:",
          color: primaryTextColor,
          fontSize: 17,
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
