import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';

class ProfileCardWidget extends StatelessWidget {
  ProfileCardWidget({super.key});
  UserInfo info = Get.find<AppStorage>().getUserInfo();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8,offset: Offset(0, 2))],
      ),
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
                Text('${UserUtils.getLoginUserName()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                Text('${UserUtils.getLoginUserTrade()}', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black, size: 35,),
            onPressed: () {
              Get.toNamed(AppRoutes.userSettingsScreen);
            },
          ),
        ],
      ),
    );
  }
}