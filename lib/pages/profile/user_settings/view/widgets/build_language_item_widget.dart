import 'package:belcka/pages/profile/user_settings/controller/user_settings_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/language_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/image/circular_svg_assets_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildLanguageItemWidget extends StatelessWidget {
  BuildLanguageItemWidget({super.key});

  final controller = Get.find<UserSettingsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final language = LanguageUtils.getLanguageByKey(
        controller.selectedLanguageKey.value,
      );

      return CardViewDashboardItem(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          leading: CircularSvgAssetsImage(
            assetsPath: language.flagAsset,
            width: 32,
            height: 32,
            radiusSize: 16,
            placeHolderSize: 32,
            fit: BoxFit.cover,
          ),
          title: Text(
            'language'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: primaryTextColor_(context),
            ),
          ),
          subtitle: Text(
            language.titleKey.tr,
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor_(context),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: controller.showLanguageBottomSheet,
        ),
      );
    });
  }
}
