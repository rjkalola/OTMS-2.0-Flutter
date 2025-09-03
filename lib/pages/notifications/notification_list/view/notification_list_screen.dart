import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/notifications/notification_list/controller/notification_list_controller.dart';
import 'package:belcka/pages/notifications/notification_list/view/widgets/notification_tab_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final controller = Get.put(NotificationListController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'notifications'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
              // widgets: actionButtons(),
            ),
            body: controller.isInternetNotAvailable.value
                ? NoInternetWidget(
                    onPressed: () {
                      controller.isInternetNotAvailable.value = false;
                      // controller.getCompanyDetailsApi();
                    },
                  )
                : Column(
                    children: [
                      NotificationTabBar(),
                      Expanded(
                        child: PageView(
                          controller: controller.pageController,
                          onPageChanged: controller.onPageChanged,
                          physics: const NeverScrollableScrollPhysics(),
                          children: controller.tabs,
                        ),
                      )
                    ],
                  )),
      ),
    );
  }
}
