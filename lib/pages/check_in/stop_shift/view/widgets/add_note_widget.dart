import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';

class AddNoteWidget extends StatelessWidget {
  AddNoteWidget(
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
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        child: TextFieldBorderDark(
          textEditingController: controller.value,
          hintText: 'enter_your_note_here'.tr,
          labelText: 'add_a_note'.tr,
          textInputAction: TextInputAction.newline,
          validator: MultiValidator([]),
          isReadOnly: isReadOnly,
          textAlignVertical: TextAlignVertical.top,
          onValueChange: onValueChange,
          borderRadius: 16,
        ),
      ),
    );
  }
}
