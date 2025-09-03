import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/image_utils.dart';

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
              url: AppStorage().getUserInfo().image ?? "",
              width: 48,
              height: 48),
          SizedBox(
            width: 12,
          ),
          Text(
              "Welcome, ${AppStorage().getUserInfo().firstName} ${AppStorage().getUserInfo().lastName}",
              style:  TextStyle(
                color: primaryTextColor_(context),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ))
        ],
      ),
    );
  }
}
