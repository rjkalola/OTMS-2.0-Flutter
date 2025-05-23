import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../../../res/colors.dart';
import '../../controller/dashboard_controller.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // return BottomNavigationBar(
      //   elevation: 0,
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         activeIcon: setActiveTab(),
      //         icon: SvgPicture.asset(Drawable.tab1Icon, width: 30),
      //         label: ''),
      //     // BottomNavigationBarItem(
      //     //     activeIcon: Image.asset(Drawable.activeProfileTabIcon, width: 26),
      //     //     icon: Image.asset(Drawable.inactiveProfileTabIcon, width: 26),
      //     //     label: ''),
      //     BottomNavigationBarItem(
      //         activeIcon:
      //             SvgPicture.asset(Drawable.activeMoreTabIcon, width: 30),
      //         icon: SvgPicture.asset(Drawable.inactiveMoreTabIcon, width: 30),
      //         label: ''),
      //   ],
      //   currentIndex: dashboardController.selectedIndex.value,
      //   type: BottomNavigationBarType.fixed,
      //   showUnselectedLabels: false,
      //   showSelectedLabels: false,
      //   backgroundColor: bottomTabBackgroundColor,
      //   onTap: dashboardController.onItemTapped,
      // );
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
                        color:
                            isSelected ? defaultAccentColor : Colors.black54),
                    // Icon(
                    //   DataUtils.tabIcons[index],
                    //   color: isSelected ? Colors.blue : Colors.black54,
                    // ),
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

  Widget setActiveTab() => Column(
        children: [
          ImageUtils.setSvgAssetsImage(
              path: Drawable.tab1Icon,
              width: 24,
              height: 24,
              color: defaultAccentColor),
          SizedBox(
            height: 4,
          ),
          PrimaryTextView(
            text: "Home",
            color: defaultAccentColor,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          )
        ],
      );
}
