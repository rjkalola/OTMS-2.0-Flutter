import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';

class ProfileCardWidget extends StatelessWidget {
  ProfileCardWidget({super.key});
  UserInfo info = Get.find<AppStorage>().getUserInfo();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CardViewDashboardItem(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          UserAvtarView(
            isOnlineStatusVisible: true,
            imageSize: 50,
            imageUrl:info.userImage ?? "",
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${UserUtils.getLoginUserName()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Text('${UserUtils.getLoginUserTrade()}', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color:primaryTextColor_(context), size: 35),
            onPressed: () {
              Get.toNamed(AppRoutes.userSettingsScreen);
            },
          ),
        ],
      ),
    );
  }
}