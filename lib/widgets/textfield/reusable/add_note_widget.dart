import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';

class AddNoteWidget extends StatelessWidget {
  AddNoteWidget(
      {super.key,
      required this.controller,
      this.onValueChange,
      this.isReadOnly,
      this.padding,
      this.borderRadius});

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: padding ?? EdgeInsets.all(0),
        child: TextFieldBorderDark(
          textEditingController: controller.value,
          hintText: 'enter_your_note_here'.tr,
          labelText: 'add_a_note'.tr,
          textInputAction: TextInputAction.newline,
          validator: MultiValidator([]),
          isReadOnly: isReadOnly,
          textAlignVertical: TextAlignVertical.top,
          onValueChange: onValueChange,
          borderRadius: borderRadius,
          maxLength: 150,
        ),
      ),
    );
  }
}
