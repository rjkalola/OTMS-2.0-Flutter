import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../res/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      this.textEditingController,
      this.hintText = "",
      this.validator,
      this.inputFormatters,
      this.cursorColor = defaultAccentColor,
      this.keyboardType,
      this.textInputAction});

  final TextEditingController? textEditingController;
  final String? hintText;
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
      style: const TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal),
      decoration: InputDecoration(
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(
            fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: defaultAccentColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: defaultAccentColor),
        ),
      ),
      validator: validator!,
      inputFormatters: inputFormatters!,
    );
  }
}
