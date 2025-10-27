import 'package:belcka/pages/profile/my_account/controller/my_account_controller.dart';
import 'package:belcka/pages/profile/my_account/full_screen_image_view/full_screen_image_view_screen.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
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
    // TODO: implement build
    return CardViewDashboardItem(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      child: GestureDetector(
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
          /*
          if (controller.isOtherUserProfile.value == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtherUserFullScreenImageViewScreen(
                  imageUrl: controller.myProfileInfo.value.userImage ?? "",
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImageViewScreen(
                  imageUrl: info.userImage ?? "",
                ),
              ),
            );
          }*/
        },
        child: Row(
          children: [
            UserAvtarView(
              isOnlineStatusVisible: true,
              imageSize: 50,
              imageUrl: controller.userInfo.value.userThumbImage ?? "",
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${controller.userInfo.value.firstName ?? ""} ${controller.userInfo.value.lastName ?? ""}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text('${controller.userInfo.value.tradeName}',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ],
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
      ),
    );
  }
}
