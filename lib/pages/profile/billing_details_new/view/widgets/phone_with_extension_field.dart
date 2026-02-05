import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/app_colors.dart';
import 'package:belcka/res/theme/theme_controller.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';


Widget PhoneWithExtensionField(String value, String label) {
  bool isDark = Get.find<ThemeController>().isDarkMode;

  bool isEmail = value.contains('@');
  bool isPhone = RegExp(r'^\+?[0-9 ]{7,}$').hasMatch(value);

  IconData? icon;
  if (isEmail) {
    icon = Icons.email_outlined;
  } else if (isPhone) {
    icon = Icons.phone_outlined;
  }

  final accentColor = isDark
      ? AppColors.defaultAccentColorDark
      : AppColors.defaultAccentColor;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: isDark ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: isDark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFFEEEEEE),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),

        /// Value row with icon
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: accentColor,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
