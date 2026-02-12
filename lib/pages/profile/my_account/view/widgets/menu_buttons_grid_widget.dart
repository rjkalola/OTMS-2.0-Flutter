import 'package:belcka/pages/my_requests/controller/my_requests_controller.dart';
import 'package:belcka/pages/my_requests/view/my_requests_screen.dart';
import 'package:belcka/pages/profile/my_account/model/my_account_menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:belcka/pages/profile/my_account/controller/my_account_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class MenuButtonsGridWidget extends StatelessWidget {
  MenuButtonsGridWidget({super.key});

  final controller = Get.put(MyAccountController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.menuItems().length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 90,
        ),
        itemBuilder: (context, index) {
          MyAccountMenuItem info = controller.menuItems()[index];
          return InkWell(
            onTap: () {
              if (info.action == AppConstants.action.billingInfo) {
                // if (controller.isOtherUserProfile.value == true) {
                //
                // } else {
                //   Get.toNamed(AppRoutes.billingDetailsNewScreen);
                // }
                var arguments = {
                  "user_id": controller.userId ?? UserUtils.getLoginUserId(),
                };
                Get.toNamed(AppRoutes.billingDetailsNewScreen,
                    arguments: arguments);
              } else if (index == 1) {
              } else if (info.action == AppConstants.action.myRequests) {
                var arguments = {
                  "user_id": controller.userId ?? 0,
                  // "isOtherUserProfile": controller.isOtherUserProfile.value
                };
                Get.toNamed(AppRoutes.myRequestsScreen, arguments: arguments);
              } else if (info.action == AppConstants.action.documents) {
                print("User ID:" + (controller.userId ?? 0).toString());
                var arguments = {
                  AppConstants.intentKey.userId: controller.userId ?? 0,
                };
                Get.toNamed(AppRoutes.paymentDocumentsScreen,
                    arguments: arguments);
              } else if (info.action == AppConstants.action.myLeaves) {
                var arguments = {
                  AppConstants.intentKey.userId: controller.userId ?? 0,
                };
                Get.toNamed(AppRoutes.leaveListScreen, arguments: arguments);
              } else if (info.action ==
                  AppConstants.action.notificationSettings) {
                var arguments = {
                  AppConstants.intentKey.userId: UserUtils.getLoginUserId(),
                };
                Get.toNamed(AppRoutes.notificationSettingsScreen,
                    arguments: arguments);
              } else if (info.action == AppConstants.action.digitalId) {
                var arguments = {
                  AppConstants.intentKey.userId: controller.userId ?? 0,
                };
                Get.toNamed(AppRoutes.digitalIdCardScreen,
                    arguments: arguments);
              }
            },
            splashColor: Colors.transparent, // Removes splash effect
            highlightColor: Colors.transparent,
            child: CardViewDashboardItem(
              padding: EdgeInsets.fromLTRB(14, 12, 10, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    info.iconData,
                    color: defaultAccentColor_(context),
                    size: 26,
                    weight: 1,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: true,
                          child: PrimaryTextView(
                            text: info.title,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            textAlign: TextAlign.center,
                            color: primaryTextColorLight_(context),
                            softWrap: true,
                            maxLine: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
