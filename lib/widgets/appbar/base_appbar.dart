import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final title;
  final isBack;
  final isCenterTitle;
  final VoidCallback? onBackPressed;
  final List<Widget>? widgets;
  final Color? bgColor;

  BaseAppBar(
      {super.key,
      required this.appBar,
      this.title,
      this.isCenterTitle,
      this.isBack = false,
      this.widgets,
      this.onBackPressed,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: bgColor ?? backgroundColor,
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: widgets,
        centerTitle: isCenterTitle,
        titleSpacing: isBack ? 0 : 20,
        automaticallyImplyLeading: isBack,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
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
