import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border_dark.dart';

class DisplayNoteWidget extends StatelessWidget {
  DisplayNoteWidget(
      {super.key,
      required this.controller,
      this.onValueChange,
      this.isReadOnly});

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible:
            !StringHelper.isEmptyString(StringHelper.getText(controller.value)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: TextFieldBorder(
            textEditingController: controller.value,
            hintText: 'note'.tr,
            labelText: 'note'.tr,
            textInputAction: TextInputAction.newline,
            validator: MultiValidator([]),
            isReadOnly: isReadOnly,
            textAlignVertical: TextAlignVertical.top,
            onValueChange: onValueChange,
            borderRadius: 16,
          ),
        ),
      ),
    );
  }
}
