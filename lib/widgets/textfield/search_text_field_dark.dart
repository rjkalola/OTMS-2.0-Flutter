import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';

import '../../res/colors.dart';

class SearchTextFieldDark extends StatelessWidget {
  const SearchTextFieldDark(
      {super.key,
      this.onValueChange,
      this.onPressedClear,
      this.label,
      this.hint,
      required this.controller,
      required this.isClearVisible,
      this.isReadOnly,
      this.onTap,
      this.autofocus,
      this.focusNode});

  final ValueChanged<String>? onValueChange;
  final VoidCallback? onPressedClear;
  final Rx<TextEditingController> controller;
  final Rx<bool> isClearVisible;
  final String? label, hint;
  final bool? isReadOnly, autofocus;
  final GestureTapCallback? onTap;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextField(
          controller: controller.value,
          onChanged: onValueChange,
          readOnly: isReadOnly ?? false,
          autofocus: autofocus ?? false,
          focusNode: focusNode,
          onTap: onTap,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: primaryTextColor_(context)),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            // prefixIcon: const Icon(Icons.search, color: primaryTextColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ThemeConfig.isDarkMode
                      ? Color(0xFF757575)
                      : Color(0xff8a8a8a),
                  width: 1),
              borderRadius: BorderRadius.all(Radius.circular(45)),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ThemeConfig.isDarkMode
                        ? Color(0xFF757575)
                        : Color(0xff8a8a8a),
                    width: 1),
                borderRadius: BorderRadius.all(Radius.circular(45))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ThemeConfig.isDarkMode
                        ? Color(0xFF757575)
                        : Color(0xff8a8a8a),
                    width: 1.4),
                borderRadius: BorderRadius.all(Radius.circular(45))),
            hintText: hint ?? 'search'.tr,
            labelText: label,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: hintColor_(context)),
            hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: hintColor_(context)),
            suffixIcon: isClearVisible.value
                ? IconButton(
                    onPressed: onPressedClear,
                    icon: const Icon(Icons.cancel),
                  )
                : Container(
                    width: 1,
                  ),
          ),
        ));
  }
}
