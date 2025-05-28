import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/managecompany/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';

class TextFieldWorkingHours extends StatelessWidget {
  TextFieldWorkingHours({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFieldBorder(
        textEditingController: controller.workingHourController.value,
        hintText: 'working_hours'.tr,
        labelText: 'working_hours'.tr,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        validator: MultiValidator([]),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
      ),
    );
  }
}
