import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/res/theme/theme_controller.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';

class BuildDarkModeItemWidget extends StatelessWidget {
  BuildDarkModeItemWidget({super.key});

  final controller = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CardViewDashboardItem(
        margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
        child:ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(
              Icons.dark_mode_outlined,
              color: primaryTextColor_(context),
              size: 32,
            ),
            title:  Text(
              'Dark mode',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: primaryTextColor_(context)),
            ),
            trailing: CustomSwitch(
              onValueChange: (value) {
                controller.toggleTheme(value);
              },
              mValue: controller.isDarkMode,
            ))
      ),
    );
  }
}
