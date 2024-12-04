import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../res/colors.dart';
import '../../controller/stock_filter_controller.dart';

class AllItems extends StatelessWidget {
  AllItems({super.key});

  final controller = Get.put(StockFilterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isAllVisible.value,
          child: InkWell(
            onTap: () {
              controller.applyFilter_(0, "All","all");
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                            softWrap: true,
                            'all'.tr,
                            style: const TextStyle(
                              color: primaryTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            )),
                      ),
                      // SvgPicture.asset(
                      //   width: 22,
                      //   Drawable.checkIcon,
                      //   colorFilter: ColorFilter.mode(
                      //       controller.categoriesList[position].check ?? false
                      //           ? defaultAccentColor
                      //           : disableComponentColor,
                      //       BlendMode.srcIn),
                      // )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 14, right: 14),
                  child: Divider(
                    color: dividerColor,
                    height: 0.5,
                    thickness: 0.5,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
