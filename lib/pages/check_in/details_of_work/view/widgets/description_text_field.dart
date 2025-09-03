import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:belcka/pages/check_in/details_of_work/controller/details_of_work_controller.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:get/get.dart';

class DescriptionTextField extends StatelessWidget {
  DescriptionTextField({super.key});

  final controller = Get.put(DetailsOfWorkController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: TextFieldBorder(
        textEditingController: controller.descriptionController.value,
        hintText: 'description'.tr,
        labelText: 'description'.tr,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        textAlignVertical: TextAlignVertical.top,
        onValueChange: (value) {

        },
      ),
    );
  }
}
