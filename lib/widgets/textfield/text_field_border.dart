import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';

import '../../res/colors.dart';

class TextFieldBorder extends StatelessWidget {
  TextFieldBorder(
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
      this.isEnable,
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
      this.borderRadius});

  final TextEditingController? textEditingController;
  final String? hintText, labelText;
  final MultiValidator? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? isReadOnly, isEnable;
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
  final double? borderRadius;

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
      enabled: isEnable ?? true,
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
          borderSide: BorderSide(color: focusedTextFieldBorderColor_(context), width: 1),
          borderRadius: BorderRadius.circular(borderRadius ?? 45.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedTextFieldBorderColor_(context), width: 1),
          borderRadius: BorderRadius.circular(borderRadius ?? 45.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: normalTextFieldBorderColor_(context), width: 1),
          borderRadius: BorderRadius.circular(borderRadius ?? 45.0),
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: ThemeConfig.isDarkMode ? Color(0xFF424242) : Colors.grey),
        hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: ThemeConfig.isDarkMode ? Color(0xFF424242) : Colors.grey),
      ),
      validator: validator!,
    );
  }
}
