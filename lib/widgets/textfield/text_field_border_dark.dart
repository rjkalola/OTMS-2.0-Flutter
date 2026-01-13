import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:belcka/res/theme/theme_config.dart';

import '../../res/colors.dart';

class TextFieldBorderDark extends StatelessWidget {
  const TextFieldBorderDark(
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
      this.isEnabled,
      this.suffixIcon,
      this.minLines,
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
      this.borderRadius,
      this.contentPadding});

  final TextEditingController? textEditingController;
  final String? hintText, labelText;
  final MultiValidator? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? isReadOnly, isEnabled;
  final Icon? suffixIcon;
  final int? maxLines, minLines, maxLength;
  final TextAlignVertical? textAlignVertical;
  final TextAlign? textAlign;
  final GestureTapCallback? onPressed;
  final ValueChanged<String>? onValueChange;
  final bool? autofocus, isDense;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final int? errorMaxLines;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onPressed,
      autofocus: autofocus ?? false,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onValueChange,
      enabled: isEnabled,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: primaryTextColor_(context)),
      controller: textEditingController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
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
        contentPadding: contentPadding ?? EdgeInsets.fromLTRB(16, 14, 16, 14),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: normalTextFieldBorderDarkColor_(context), width: 1),
          borderRadius: BorderRadius.circular(borderRadius ?? 45.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: focusedTextFieldBorderDarkColor_(context), width: 1.6),
          borderRadius: BorderRadius.circular(borderRadius ?? 45.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: normalTextFieldBorderDarkColor_(context), width: 1),
          borderRadius: BorderRadius.circular(borderRadius ?? 45.0),
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
