import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/theme/theme_controller.dart';
import 'package:otm_inventory/utils/app_utils.dart';

Widget PhoneWithExtensionField(String value, String label) {
  bool isDark = Get.find<ThemeController>().isDarkMode;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
            width:  1,
            color:(isDark
                ? Color(AppUtils.haxColor("#1A1A1A"))
                : Color(AppUtils.haxColor("#EEEEEE")))
        )),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
      ],
    ),
  );
}
