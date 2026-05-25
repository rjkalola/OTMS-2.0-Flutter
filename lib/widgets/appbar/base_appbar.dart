import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/textfield/search_text_field_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final title;
  final isBack;
  final isCenterTitle;
  final VoidCallback? onBackPressed;
  final List<Widget>? widgets;
  final Color? bgColor;
  final Color? foregroundColor;
  final bool? isSearching, autoFocus;
  final ValueChanged<String>? onValueChange;
  final Rx<TextEditingController>? searchController;
  final Rx<bool>? isClearVisible;
  final VoidCallback? onPressedClear;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final String? searchHint;
  final String? searchLabel;

  BaseAppBar(
      {super.key,
      required this.appBar,
      this.title,
      this.isCenterTitle,
      this.isBack = false,
      this.widgets,
      this.onBackPressed,
      this.bgColor,
      this.foregroundColor,
      this.isSearching,
      this.searchController,
      this.onValueChange,
      this.isClearVisible,
      this.onPressedClear,
      this.autoFocus,
      this.systemOverlayStyle,
      this.shape,
      this.elevation,
      this.shadowColor,
      this.surfaceTintColor,
      this.searchHint,
      this.searchLabel});

  @override
  Widget build(BuildContext context) {
    final Color fg = foregroundColor ?? primaryTextColor_(context);
    return AppBar(
        shape: shape,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        systemOverlayStyle: systemOverlayStyle,
        foregroundColor: foregroundColor,
        backgroundColor: bgColor ?? backgroundColor_(context),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: (isSearching ?? false)
              ? SearchTextFieldAppBar(
                  controller: searchController!,
                  isClearVisible: true.obs,
                  autofocus: autoFocus,
                  onValueChange: onValueChange,
                  onPressedClear: onPressedClear,
                  hint: searchHint,
                  label: searchLabel,
                )
              : Text(
                  title,
                  style: TextStyle(
                      color: fg, fontSize: 18, fontWeight: FontWeight.w500),
                ),
        ),
        actions: widgets,
        centerTitle: isCenterTitle,
        titleSpacing: (isBack || onBackPressed != null) ? 0 : 20,
        automaticallyImplyLeading: isBack,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: fg,
          ),
          onPressed: () {
            onBackPressed != null ? onBackPressed!() : Get.back();
          },
        ),
        scrolledUnderElevation: 0);
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
