import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_constants.dart';

class CommonBottomNavigationBarWidget extends StatelessWidget {
  CommonBottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: AppUtils.getDashboardItemDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(DataUtils.tabIcons.length, (index) {
            return GestureDetector(
              onTap: () {
                var arguments = {
                  AppConstants.intentKey.dashboardTabIndex: index,
                };
                Get.offAllNamed(AppRoutes.dashboardScreen,
                    arguments: arguments);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageUtils.setSvgAssetsImage(
                    path: DataUtils.tabIcons[index],
                    width: 24,
                    height: 24,
                    color: ThemeConfig.isDarkMode
                        ? Colors.white54
                        : Colors.black54,
                  )
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 4.0),
                  //   child: Text(
                  //     DataUtils.tabLabels[index],
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: defaultAccentColor_(context),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
