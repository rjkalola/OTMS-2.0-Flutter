import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';

class AddNoteWidget extends StatelessWidget {
  AddNoteWidget({
    super.key,
    required this.controller,
    this.onValueChange,
    this.isReadOnly,
    this.padding,
  });

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 18),
        child: TextFieldBorderDark(
          textEditingController: controller.value,
          hintText: 'enter_your_note_here'.tr,
          labelText: 'add_a_note'.tr,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 3,
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
