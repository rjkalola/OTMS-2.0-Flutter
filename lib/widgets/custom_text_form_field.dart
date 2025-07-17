import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../res/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      this.textEditingController,
      this.hintText = "",
      this.labelText = "",
      this.validator,
      this.inputFormatters,
      this.cursorColor = defaultAccentColor,
      this.keyboardType,
      this.textInputAction});

  final TextEditingController? textEditingController;
  final String? hintText, labelText;
  final MultiValidator? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: cursorColor,
      controller: textEditingController,
      style: TextStyle(
          fontSize: 16,
          color: primaryTextColor_(context),
          fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(
            fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: normalTextFieldBorderColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: defaultAccentColor),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: normalTextFieldBorderColor),
        ),
      ),
      validator: validator!,
      inputFormatters: inputFormatters!,
    );
  }
}
