import 'package:belcka/pages/add_trades/controller/add_trades_controller.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

class CisFieldSelectView extends StatelessWidget {
  CisFieldSelectView({super.key});

  final controller = Get.put(BillingInfoController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: TextFieldBorder(
          textEditingController: controller.cisController.value,
          hintText: 'cis'.tr,
          labelText: 'cis'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          validator: MultiValidator([]),
          onPressed: () {
            controller.showCISList();
          }),
    );
  }
}