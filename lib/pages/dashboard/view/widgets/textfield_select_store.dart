import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/controller/dashboard_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class TextFieldSelectStoreHomeTab extends StatelessWidget {
  TextFieldSelectStoreHomeTab({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: TextFieldBorder(
          textEditingController: dashboardController.storeNameController.value,
          hintText: 'select_store'.tr,
          labelText: 'store'.tr,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: MultiValidator([]),
          isReadOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          onPressed: () {
            dashboardController.selectStore();
          }),
    );
  }
}
