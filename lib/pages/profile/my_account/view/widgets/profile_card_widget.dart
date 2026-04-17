import 'package:belcka/pages/profile/my_account/controller/my_account_controller.dart';
import 'package:belcka/pages/profile/my_account/full_screen_image_view/full_screen_image_view_screen.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileCardWidget extends StatelessWidget {
  ProfileCardWidget({super.key});

  final controller = Get.put(MyAccountController());

  @override
  Widget build(BuildContext context) {
    bool isWorking = controller.isOtherUserProfile.value
        ? (controller.userInfo.value.isWorking ?? false)
        : true;
    return CardViewDashboardItem(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenImageViewScreen(
                    imageUrl: controller.userInfo.value.userImage ?? "",
                    isLoginUser: UserUtils.isLoginUser(controller.userId),
                  ),
                ),
              );
            },
            child: UserAvtarView(
              isOnlineStatusVisible: true,
              onlineStatusColor: isWorking ? Colors.green : Colors.redAccent,
              imageSize: 50,
              imageUrl: controller.userInfo.value.userThumbImage ?? "",
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                var arguments = {
                  AppConstants.intentKey.userId: controller.userId
                };
                Get.toNamed(AppRoutes.personalInfoScreen, arguments: arguments);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${controller.userInfo.value.firstName ?? ""} ${controller.userInfo.value.lastName ?? ""}',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  !StringHelper.isEmptyString(
                          controller.userInfo.value.tradeName)
                      ? Text('${controller.userInfo.value.tradeName}',
                          style: TextStyle(
                              color: secondaryTextColor_(context),
                              fontWeight: FontWeight.w400,
                              fontSize: 13))
                      : Container(),
                  controller.isOtherUserProfile.value &&
                          !StringHelper.isEmptyString(
                              controller.userInfo.value.lastWorkedDate)
                      ? Text(
                          '${'last_working_date'.tr}: ${controller.userInfo.value.lastWorkedDate}',
                          style: TextStyle(
                              color: secondaryTextColor_(context),
                              fontWeight: FontWeight.w400,
                              fontSize: 13))
                      : Container(),
                ],
              ),
            ),
          ),
          Visibility(
            visible: UserUtils.isLoginUser(controller.userId),
            child: IconButton(
              icon: Icon(Icons.settings,
                  color: primaryTextColor_(context), size: 35),
              onPressed: () {
                Get.toNamed(AppRoutes.userSettingsScreen);
              },
            ),
          ),
        ],
      ),
    );
  }
}
