import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';

class WriteAnnouncement extends StatelessWidget {
  WriteAnnouncement(
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
      () => TextFieldBorderDark(
        textEditingController: controller.value,
        hintText: 'write_announcement'.tr,
        labelText: 'write_announcement'.tr,
        textInputAction: TextInputAction.newline,
        validator: MultiValidator([]),
        isReadOnly: isReadOnly,
        textAlignVertical: TextAlignVertical.top,
        onValueChange: onValueChange,
      ),
    );
  }
}
