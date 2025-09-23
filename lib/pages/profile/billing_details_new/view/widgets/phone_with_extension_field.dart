import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/app_colors.dart';
import 'package:belcka/res/theme/theme_controller.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';


Widget PhoneWithExtensionField(String value, String label) {
  bool isDark = Get.find<ThemeController>().isDarkMode;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: (isDark
          ? Colors.black
          : Colors.white),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(blurRadius: 4, color:(isDark
          ? Color(AppUtils.haxColor("#1A1A1A"))
          : Color(AppUtils.haxColor("#EEEEEE")))
      )],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, color: (isDark
            ? AppColors.defaultAccentColorDark : AppColors.defaultAccentColor))),
      ],
    ),
  );
}
