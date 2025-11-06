import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_controller.dart';
import 'package:belcka/utils/app_utils.dart';

class NavigationCard extends StatelessWidget {
  final String label;
  final dynamic value; // <-- changed from String to dynamic to allow Widget or String
  final bool isShowArrow;

  const NavigationCard({
    this.label = "",
    required this.value,
    this.isShowArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.find<ThemeController>().isDarkMode;

    Widget valueWidget;
    if (value is String) {
      // normal string text
      valueWidget = Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: primaryTextColor_(context),
        ),
        softWrap: true,
      );
    } else if (value is Widget) {
      // custom widget (like RichText)
      valueWidget = value;
    } else {
      // fallback to empty
      valueWidget = const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          width: 1,
          color: isDark
              ? Color(AppUtils.haxColor("#1A1A1A"))
              : Color(AppUtils.haxColor("#EEEEEE")),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: label.isEmpty
                ? valueWidget
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xff999999),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                valueWidget,
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isShowArrow)
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: primaryTextColor_(context),
              ),
            ),
        ],
      ),
    );
  }
}