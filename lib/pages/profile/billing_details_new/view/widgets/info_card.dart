import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_controller.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import '../../../../authentication/login/view/widgets/phone_extension_field_widget.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;
  const InfoCard({this.label = "", required this.value, this.isLink = false});

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.find<ThemeController>().isDarkMode;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Text(label, style: TextStyle(color:Color(0xff999999), fontSize: 16,fontWeight: FontWeight.w400)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                color: isLink ? defaultAccentColor_(context) : primaryTextColor_(context),
                fontWeight: FontWeight.w400,fontSize: 16),
          ),
        ],
      ),
    );
  }
}