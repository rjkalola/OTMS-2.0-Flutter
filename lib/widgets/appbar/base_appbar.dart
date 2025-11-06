import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/textfield/search_text_field_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final title;
  final isBack;
  final isCenterTitle;
  final VoidCallback? onBackPressed;
  final List<Widget>? widgets;
  final Color? bgColor;
  final bool? isSearching, autoFocus;
  final ValueChanged<String>? onValueChange;
  final Rx<TextEditingController>? searchController;
  final Rx<bool>? isClearVisible;

  BaseAppBar(
      {super.key,
      required this.appBar,
      this.title,
      this.isCenterTitle,
      this.isBack = false,
      this.widgets,
      this.onBackPressed,
      this.bgColor,
      this.isSearching,
      this.searchController,
      this.onValueChange,
      this.isClearVisible,
      this.autoFocus});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: bgColor ?? backgroundColor_(context),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: (isSearching ?? false)
              ? SearchTextFieldAppBar(
                  controller: searchController!,
                  isClearVisible: isClearVisible!,
                  autofocus: autoFocus,
                  onValueChange: onValueChange)
              : Text(
                  title,
                  style: TextStyle(
                      color: primaryTextColor_(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
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
            color: primaryTextColor_(context),
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
