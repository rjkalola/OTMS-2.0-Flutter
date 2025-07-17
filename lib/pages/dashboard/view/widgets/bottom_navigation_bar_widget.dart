import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';

import '../../../../res/colors.dart';
import '../../controller/dashboard_controller.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: AppUtils.getDashboardItemDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(DataUtils.tabIcons.length, (index) {
              final isSelected =
                  dashboardController.selectedIndex.value == index;
              return GestureDetector(
                onTap: () {
                  dashboardController.selectedIndex.value = index;
                  dashboardController.onItemTapped(index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageUtils.setSvgAssetsImage(
                        path: DataUtils.tabIcons[index],
                        width: 24,
                        height: 24,
                        color: isSelected
                            ? defaultAccentColor_(context)
                            : ThemeConfig.isDarkMode
                                ? Colors.white54
                                : Colors.black54),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          DataUtils.tabLabels[index],
                          style: TextStyle(
                            fontSize: 12,
                            color: defaultAccentColor,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}
