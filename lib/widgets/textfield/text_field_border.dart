import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../res/colors.dart';

class TextFieldBorder extends StatelessWidget {
  const TextFieldBorder(
      {super.key,
      this.textEditingController,
      this.hintText = "",
      this.labelText = "",
      this.validator,
      this.inputFormatters,
      this.cursorColor = defaultAccentColor,
      this.keyboardType,
      this.textInputAction,
      this.isReadOnly,
      this.suffixIcon,
      this.maxLines,
      this.textAlignVertical,
      this.autofocus,
      this.textAlign,
      this.onPressed,
      this.onValueChange,
      this.isDense,
      this.autovalidateMode});

  final TextEditingController? textEditingController;
  final String? hintText, labelText;
  final MultiValidator? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? isReadOnly;
  final Icon? suffixIcon;
  final int? maxLines;
  final TextAlignVertical? textAlignVertical;
  final TextAlign? textAlign;
  final VoidCallback? onPressed;
  final ValueChanged<String>? onValueChange;
  final bool? autofocus, isDense;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        onPressed!();
      },
      autofocus: autofocus ?? false,
      onChanged: onValueChange,
      style: const TextStyle(
          fontWeight: FontWeight.w400, fontSize: 15, color: primaryTextColor),
      controller: textEditingController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      textAlignVertical: textAlignVertical,
      textAlign: textAlign ?? TextAlign.start,
      readOnly: isReadOnly ?? false,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        isDense: isDense ?? false,
        suffixIcon: suffixIcon,
        counterText: "",
        contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: focusedTextFieldBorderColor, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: focusedTextFieldBorderColor, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: normalTextFieldBorderColor, width: 1),
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
      ),
      validator: validator!,
    );
  }
}
