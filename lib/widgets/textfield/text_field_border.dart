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
      this.maxLength,
      this.textAlignVertical,
      this.autofocus,
      this.textAlign,
      this.onPressed,
      this.onValueChange,
      this.isDense,
      this.autovalidateMode,
      this.focusNode,
      this.onFieldSubmitted,
      this.errorMaxLines});

  final TextEditingController? textEditingController;
  final String? hintText, labelText;
  final MultiValidator? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? isReadOnly;
  final Icon? suffixIcon;
  final int? maxLines, maxLength;
  final TextAlignVertical? textAlignVertical;
  final TextAlign? textAlign;
  final GestureTapCallback? onPressed;
  final ValueChanged<String>? onValueChange;
  final bool? autofocus, isDense;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final int? errorMaxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onPressed,
      autofocus: autofocus ?? false,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onValueChange,
      style: const TextStyle(
          fontWeight: FontWeight.w400, fontSize: 15, color: primaryTextColor),
      controller: textEditingController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      textAlignVertical: textAlignVertical,
      textAlign: textAlign ?? TextAlign.start,
      readOnly: isReadOnly ?? false,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        errorMaxLines: errorMaxLines ?? 2,
        isDense: isDense ?? false,
        suffixIcon: suffixIcon,
        counterText: "",
        contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: focusedTextFieldBorderColor, width: 1),
          borderRadius: BorderRadius.circular(45.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedTextFieldBorderColor, width: 1),
          borderRadius: BorderRadius.circular(45.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: normalTextFieldBorderColor, width: 1),
          borderRadius: BorderRadius.circular(45.0),
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),
      ),
      validator: validator!,
    );
  }
}
