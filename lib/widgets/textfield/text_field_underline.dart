import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../res/colors.dart';

class TextFieldUnderline extends StatelessWidget {
  const TextFieldUnderline(
      {super.key,
      this.textEditingController,
      this.hintText = "",
      this.labelText = "",
      this.validator,
      this.inputFormatters,
      this.cursorColor,
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
      this.errorMaxLines,
        this.isEnabled});

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
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onPressed,
      autofocus: autofocus ?? false,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onValueChange,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: primaryTextColor_(context)),
      controller: textEditingController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      textAlignVertical: textAlignVertical,
      textAlign: textAlign ?? TextAlign.start,
      readOnly: isReadOnly ?? false,
      enabled: isEnabled ?? false,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        errorMaxLines: errorMaxLines ?? 2,
        isDense: isDense ?? false,
        suffixIcon: suffixIcon,
        counterText: "",
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: normalTextFieldBorderColor_(context), width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: focusedTextFieldBorderColor_(context), width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: normalTextFieldBorderColor_(context), width: 1),
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: hintColor_(context)),
        hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: hintColor_(context)),
      ),
      validator: validator!,
    );
  }
}
