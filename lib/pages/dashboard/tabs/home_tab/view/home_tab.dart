import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/view/widgets/dashboard_grid_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/view/widgets/header_user_details_view.dart';

import '../../../../../res/colors.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // with AutomaticKeepAliveClientMixin {
  final controller = Get.put(HomeTabController());
  late var userInfo = UserInfo();
  int selectedActionButtonPagerPosition = 0;

  @override
  void initState() {
    // showProgress();
    // setHeaderActionButtons();
    // userInfo = Get.find<AppStorage>().getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: dashBoardBgColor,
        // backgroundColor: const Color(0xfff4f5f7),
        body: Visibility(
          visible: controller.isMainViewVisible.value,
          child: SingleChildScrollView(
            child: Column(children: [
              HeaderUserDetailsView(),
              SizedBox(
                height: 12,
              ),
              DashboardGridView()
            ]),
          ),
        ),
      ),
    );
  }

// @override
// bool get wantKeepAlive => true;

// @override
// void dispose() {
//   homeTabController.dispose();
//   super.dispose();
// }
}
