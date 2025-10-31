import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';

class AddNoteWidget extends StatelessWidget {
  AddNoteWidget(
      {super.key,
      required this.controller,
      this.onValueChange,
      this.isReadOnly,
      this.title,});

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        child: TextFieldBorder(
          textEditingController: controller.value,
          hintText: title ?? 'add_a_note'.tr,
          labelText: title ?? 'add_a_note'.tr,
          textInputAction: TextInputAction.newline,
          validator: MultiValidator([
            if (!UserUtils.isAdmin())
              MinLengthValidator(60, errorText: 'note_min_length_error'.tr),
            if (!UserUtils.isAdmin())
              MaxLengthValidator(500, errorText: 'note_max_length_error'.tr),
          ]),
          isReadOnly: isReadOnly,
          textAlignVertical: TextAlignVertical.top,
          onValueChange: onValueChange,
          borderRadius: 16,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }
}
