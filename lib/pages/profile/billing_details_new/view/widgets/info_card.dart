import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_controller.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;

  const InfoCard({
    this.label = "",
    required this.value,
    this.isLink = false,
  });

  bool get _isEmail => value.contains('@');
  bool get _isPhone => RegExp(r'^\+?[0-9 ]{7,}$').hasMatch(value);

  IconData? get _icon {
    if (_isEmail) return Icons.email_outlined;
    if (_isPhone) return Icons.phone_outlined;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.find<ThemeController>().isDarkMode;

    final textColor = isLink
        ? defaultAccentColor_(context)
        : primaryTextColor_(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: isDark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFFEEEEEE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: const TextStyle(
                color: Color(0xff999999),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_icon != null) ...[
                Icon(
                  _icon,
                  size: 18,
                  color: textColor,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}