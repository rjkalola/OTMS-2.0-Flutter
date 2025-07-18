import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/theme/theme_controller.dart';
import 'package:otm_inventory/utils/app_utils.dart';

class NavigationCard extends StatelessWidget {
  final String label;
  final String value;

  const NavigationCard({this.label = "", required this.value});

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.find<ThemeController>().isDarkMode;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
              width: 1,
              color: (isDark
                  ? Color(AppUtils.haxColor("#1A1A1A"))
                  : Color(AppUtils.haxColor("#EEEEEE")))
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // center the arrow vertically
        children: [
          Expanded(
            child: label.isEmpty
                ? Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: primaryTextColor_(context),
              ),
              softWrap: true,
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Color(0xff999999),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: primaryTextColor_(context)
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Align(
            alignment: Alignment.center, // ensures the arrow is centered
            child: Icon(Icons.arrow_forward_ios, size: 20, color: primaryTextColor_(context)),
          ),
        ],
      ),
    );
  }
}