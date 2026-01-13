import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/textfield/text_field_underline_.dart';

class CategoryNameTextField extends StatelessWidget {
  CategoryNameTextField({
    super.key,
    required this.controller,
    this.onValueChange,
    this.isReadOnly,
    this.isEnabled,
  });

  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => TextFieldUnderline(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textEditingController: controller.value,
        hintText: "",
        labelText: 'name'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        isReadOnly: isReadOnly,
        isEnabled: isEnabled,
        onValueChange: onValueChange,
        onPressed: () {},
        validator: MultiValidator([
          RequiredValidator(errorText: 'required_field'.tr),
        ]),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
          LengthLimitingTextInputFormatter(50), // max 50 chars
        ],
      ),
    );
  }
}