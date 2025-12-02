import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:belcka/pages/company/selectcompanytrade/controller/select_company_trade_controller.dart';
import 'package:belcka/pages/company/selectcompanytrade/view/select_company_trade_screen.dart';
import 'package:belcka/pages/profile/rates/controller/rates_controller.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

class TradeView extends StatelessWidget {
  TradeView({super.key});

  final controller = Get.put(RatesController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trade
        Text(
          "trade".tr,
          style: TextStyle(fontSize: 14),
        ),

        SizedBox(height: 4),
        Text(
          controller.tradeController.value.text ?? "",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Divider(height: 12),
        SizedBox(height: 14),
      ],
    );
  }
}