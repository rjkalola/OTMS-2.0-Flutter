import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class UserScoreView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  UserScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isValidBoolValue(
            controller.dashboardResponse.value.isOwner)
        ? Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryTextView(
                      text: 'your_weekly_score_is'.tr,
                      color: primaryTextColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                    PrimaryTextView(
                      text:
                          "${controller.dashboardResponse.value.overallRating ?? 0}%",
                      color:
                          (controller.dashboardResponse.value.overallRating ??
                                      0) <=
                                  40
                              ? Colors.red
                              : Colors.green,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (controller.dashboardResponse.value.overallRating ??
                            0) /
                        100,
                    // 50% progress
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        (controller.dashboardResponse.value.overallRating ??
                                    0) <=
                                40
                            ? Colors.red
                            : Colors.green),
                  ),
                )
              ],
            ),
          )
        : Container();
  }
}
