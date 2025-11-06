import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors.dart';

class SearchTextFieldAppBar extends StatelessWidget {
  const SearchTextFieldAppBar(
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
    return Obx(() => SizedBox(
          height: 44,
          child: TextField(
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
              filled: true,
              // 👈 enables background color
              fillColor: lightGreyColor(context),
              // 👈
              // prefixIcon: const Icon(Icons.search, color: primaryTextColor),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(45)),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(45))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
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
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 6),
                child: ImageUtils.setSvgAssetsImage(
                    path: Drawable.searchIcon,
                    width: 22,
                    height: 22,
                    color: hintColor_(context)),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 22, // space reserved for icon
                minHeight: 22, // space reserved for icon
              ),
              suffixIcon: isClearVisible.value
                  ? IconButton(
                      onPressed: onPressedClear,
                      icon: const Icon(Icons.cancel),
                    )
                  : Container(
                      width: 1,
                    ),
            ),
          ),
        ));
  }
}
