import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:belcka/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';

class CustomTitleTextField extends StatelessWidget {
  final String title, label;
  final EdgeInsetsGeometry? padding;

  CustomTitleTextField(
      {super.key, required this.title, required this.label, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: TextFieldBorderDark(
        textEditingController: TextEditingController(text: title),
        hintText: label,
        labelText: label,
        isReadOnly: false,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        validator: MultiValidator([]),
      ),
    );
  }
}
