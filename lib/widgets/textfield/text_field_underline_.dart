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
      this.autovalidateMode,
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
  final int? maxLines;
  final TextAlignVertical? textAlignVertical;
  final TextAlign? textAlign;
  final VoidCallback? onPressed;
  final ValueChanged<String>? onValueChange;
  final bool? autofocus, isDense;
  final AutovalidateMode? autovalidateMode;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        onPressed!();
      },
      autofocus: autofocus ?? false,
      onChanged: onValueChange,
      style:  TextStyle(
          fontWeight: FontWeight.w400, fontSize: 15, color: primaryTextColor_(context)),
      controller: textEditingController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      textAlignVertical: textAlignVertical,
      textAlign: textAlign ?? TextAlign.start,
      readOnly: isReadOnly ?? false,
      enabled: isEnabled,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        isDense: isDense ?? false,
        suffixIcon: suffixIcon,
        counterText: "",
        contentPadding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: normalTextFieldBorderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: focusedTextFieldBorderColor, width: 2),
        ),
        // errorBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: normalTextFieldBorderColor),
        // ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: focusedTextFieldBorderColor, width: 2),
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
