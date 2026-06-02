import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class LeaveNote extends StatelessWidget {
  LeaveNote(
      {super.key,
      required this.controller,
      this.onValueChange,
      this.isReadOnly,
      this.title});

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !StringHelper.isEmptyString(controller.value.text),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextFieldBorder(
            textEditingController: controller.value,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            hintText: title ?? 'note'.tr,
            labelText: title ?? 'note'.tr,
            textInputAction: TextInputAction.newline,
            validator: MultiValidator([]),
            isReadOnly: true,
            textAlignVertical: TextAlignVertical.top,
            borderRadius: 15,
            textAlign: TextAlign.start,
            onValueChange: onValueChange,
          ),
        ),
      ),
    );
  }
}
