import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final title;
  final isBack;
  final isCenterTitle;
  final List<Widget>? widgets;

  BaseAppBar(
      {super.key,
      required this.appBar,
      this.title,
      this.isCenterTitle,
      this.isBack = false,
      this.widgets});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
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
            Get.back();
          },
        ),
        scrolledUnderElevation: 0);
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
