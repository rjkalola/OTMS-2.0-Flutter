import 'package:flutter/material.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';

class DialogHandleWidget extends StatelessWidget {
  const DialogHandleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 6,
      decoration: AppUtils.getGrayBorderDecoration(
          color: Color(AppUtils.haxColor(ThemeConfig.isDarkMode?"#525252":"#ADADAD"))),
    );
  }
}
