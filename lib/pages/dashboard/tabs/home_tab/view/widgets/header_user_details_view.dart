import 'package:flutter/material.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/shapes/badge_count_with_child_widget.dart';
import 'package:belcka/widgets/shapes/circle_widget.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HeaderUserDetailsView extends StatelessWidget {
  HeaderUserDetailsView({super.key});

  final controller = Get.put(HomeTabController());

  String getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMM'); // "Monday, 17 Apr"
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: EdgeInsets.fromLTRB(14, 20, 14, 6),
      padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: GestureDetector(
        onTap: () {
          controller.moveToScreen(appRout: AppRoutes.myAccountScreen);
        },
        child: Row(
          children: [
            UserAvtarView(
              imageUrl: controller.userInfo?.userThumbImage ?? "",
              isOnlineStatusVisible: true,
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
                    color: primaryTextColorLight_(context),
                    softWrap: true,
                  ),
                  PrimaryTextView(
                    text: getFormattedDate(),
                    color: secondaryExtraLightTextColor_(context),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    softWrap: true,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.notificationListScreen);
              },
              child: BudgeCountWithChild(
                  count: 0,
                  child: ImageUtils.setSvgAssetsImage(
                      path: Drawable.bellIcon,
                      width: 28,
                      height: 28,
                      color: ThemeConfig.isDarkMode
                          ? AppUtils.getColor("#B7B3AD")
                          : AppUtils.getColor("#484C52"))),
            )
          ],
        ),
      ),
    );
  }
}
