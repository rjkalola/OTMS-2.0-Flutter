import 'package:belcka/pages/analytics/user_analytics/controller/user_analytics_controller.dart';
import 'package:belcka/pages/profile/my_account/full_screen_image_view/full_screen_image_view_screen.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAnalyticsHeaderView extends StatelessWidget {
  UserAnalyticsHeaderView({super.key});

  final controller = Get.put(UserAnalyticsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewScreen(
                          imageUrl:
                              controller.userAnalytics.value?.userImage ?? "",
                          isLoginUser: UserUtils.isLoginUser(controller.userId),
                        ),
                      ),
                    );
                  },
                  child: UserAvtarView(
                    isOnlineStatusVisible: true,
                    imageSize: 50,
                    imageUrl:
                        controller.userAnalytics.value?.userImageThumb ?? "",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      var arguments = {
                        AppConstants.intentKey.userId: controller.userId
                      };
                      Get.toNamed(AppRoutes.personalInfoScreen,
                          arguments: arguments);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.userAnalytics.value?.userName ?? "",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        Text(controller.userAnalytics.value?.tradeName ?? "",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
