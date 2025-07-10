import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/shapes/badge_count_widget.dart';
import 'package:otm_inventory/widgets/shapes/badge_count_with_child_widget.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:get/get.dart';

class HeaderUserDetailsView extends StatelessWidget {
  HeaderUserDetailsView({super.key});

  final controller = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(14, 20, 14, 0),
      decoration: AppUtils.getDashboardItemDecoration(
          borderWidth: 2, borderColor: dashBoardItemStrokeColor, radius: 20),
      padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              controller. moveToScreen(appRout: AppRoutes.myAccountScreen);
            },
            child: UserAvtarView(
              imageUrl: controller.userInfo?.userThumbImage ?? "",
              isOnlineStatusVisible: true,
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryTextView(
                  text:
                      "Hi, ${controller.userInfo?.firstName} ${controller.userInfo?.lastName}",
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: primaryTextColorLight,
                  softWrap: true,
                ),
                PrimaryTextView(
                  text: "Monday, 17 Apr",
                  color: secondaryExtraLightTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  softWrap: true,
                )
              ],
            ),
          ),
          BudgeCountWithChild(
              child: ImageUtils.setSvgAssetsImage(
                  path: Drawable.bellIcon, width: 28, height: 28),
              count: 5)
        ],
      ),
    );
  }
}
