import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';

class LeaveNote extends StatelessWidget {
  LeaveNote(
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
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: TextFieldBorderDark(
          textEditingController: controller.value,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          hintText: 'manager_note'.tr,
          labelText: 'manager_note'.tr,
          textInputAction: TextInputAction.newline,
          validator: MultiValidator([]),
          isReadOnly: isReadOnly,
          minLines: 3,
          maxLength: 150,
          textAlignVertical: TextAlignVertical.top,
          borderRadius: 15,
          textAlign: TextAlign.start,
          onValueChange: onValueChange,
        ),
      ),
    );
  }
}
