import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:belcka/pages/company/selectcompanytrade/controller/select_company_trade_controller.dart';
import 'package:belcka/pages/company/selectcompanytrade/view/select_company_trade_screen.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

class SelectTradeView extends StatelessWidget {
  SelectTradeView({super.key});

  final controller = Get.put(SelectCompanyTradeController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
      child: TextFieldBorder(
          textEditingController: controller.selectTradeController.value,
          hintText: 'select_trade'.tr,
          labelText: 'select_trade'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          validator: MultiValidator([]),
          onPressed: () {
            controller.showTradeList();
          }),
    );
  }
}
