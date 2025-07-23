import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:otm_inventory/pages/profile/personal_info/controller/personal_info_controller.dart';
import 'package:otm_inventory/widgets/textfield/text_field_border_dark.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline_.dart';

class DropDownTextField extends StatelessWidget {
  DropDownTextField({super.key,
    required this.title,
    required this.controller,
    this.onValueChange,
    this.isReadOnly,
    this.isEnabled,
    this.validators,
    this.onPressed,
    this.borderRadius,
    this.isArrowHide});

  final String title;
  final Rx<TextEditingController> controller;
  final ValueChanged<String>? onValueChange;
  final bool? isReadOnly, isEnabled, isArrowHide;
  final List<FieldValidator>? validators;
  final GestureTapCallback? onPressed;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Obx(
            () =>
            TextFieldBorderDark(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textEditingController: controller.value,
                hintText: title,
                labelText: title,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                isReadOnly: isReadOnly ?? true,
                suffixIcon: !(isArrowHide??false)?const Icon(Icons.arrow_drop_down):null,
                isEnabled: isEnabled,
                onValueChange: onValueChange,
                onPressed: onPressed,
            validator: MultiValidator(validators ?? []),
        borderRadius: borderRadius,
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
        ]),);
  }
}
