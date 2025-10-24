import 'package:belcka/pages/profile/other_user_account/controller/other_user_account_controller.dart';
import 'package:belcka/pages/profile/other_user_account/other_user_full_screen_image_view/other_user_full_screen_image_view_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';

class OtherUserProfileCardWidget extends StatelessWidget {
  OtherUserProfileCardWidget({super.key});

  final controller = Get.put(OtherUserAccountController());

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
              builder: (_) => OtherUserFullScreenImageViewScreen(
                imageUrl: controller.myProfileInfo.value.userImage ?? "",
              ),
            ),
          );
        },
        child: Row(
          children: [
            UserAvtarView(
              isOnlineStatusVisible: true,
              imageSize: 50,
              imageUrl:controller.myProfileInfo.value.userThumbImage ?? "",
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${controller.myProfileInfo.value.firstName ?? ""} ${controller.myProfileInfo.value.lastName ?? ""}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text('${controller.myProfileInfo.value.tradeName}', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}