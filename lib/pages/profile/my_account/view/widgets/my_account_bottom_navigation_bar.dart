import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/my_account/controller/my_account_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class MyAccountBottomNavigationBar extends StatelessWidget {
  MyAccountBottomNavigationBar({super.key});

  final controller = Get.put(MyAccountController());

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
                  controller.selectedIndex.value == index;
              return GestureDetector(
                onTap: () {
                  controller.selectedIndex.value = index;
                  controller.onItemTapped(index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageUtils.setSvgAssetsImage(
                        path: DataUtils.tabIcons[index],
                        width: 24,
                        height: 24,
                        color:
                        isSelected ? defaultAccentColor_(context) : Colors.black54),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          DataUtils.tabLabels[index],
                          style: TextStyle(
                            fontSize: 12,
                            color: defaultAccentColor_(context),
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
          color: defaultAccentColor_(Get.context!)),
      SizedBox(
        height: 4,
      ),
      PrimaryTextView(
        text: "Home",
        color: defaultAccentColor_(Get.context!),
        fontWeight: FontWeight.w400,
        fontSize: 14,
      )
    ],
  );
}