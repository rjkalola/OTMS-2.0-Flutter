import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/view/widgets/dashboard_grid_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/view/widgets/header_user_details_view.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

import '../../../../../res/colors.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
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
        body: controller.isInternetNotAvailable.value
            ? NoInternetWidget(
                onPressed: () {
                  controller.isInternetNotAvailable.value = false;
                  controller.getDashboardUserPermissionsApi(true);
                },
              )
            : ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: Visibility(
                  visible: controller.isMainViewVisible.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      HeaderUserDetailsView(),
                      // EditWidgetsButton(),
                      SizedBox(
                        height: 12,
                      ),
                       DashboardGridView()
                      // DashboardGridView()
                    ],
                  ),
                ),
              ),

        /* body: Visibility(
          visible: controller.isMainViewVisible.value,
          child: Column(children: [
            HeaderUserDetailsView(),
            SizedBox(
              height: 12,
            ),
            DashboardGridView()
          ]),
        ),*/
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
