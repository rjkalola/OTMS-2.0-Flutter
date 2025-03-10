import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/image_utils.dart';

class HomeTabHeaderView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  HomeTabHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          ImageUtils.setUserImage(
              AppStorage().getUserInfo().image ?? "", 48, 48),
          SizedBox(
            width: 12,
          ),
          Text(
              "Welcome, ${AppStorage().getUserInfo().firstName} ${AppStorage().getUserInfo().lastName}",
              style: const TextStyle(
                color: primaryTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ))
        ],
      ),
    );
  }
}
