import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/profile/my_account/controller/my_account_controller.dart';
import 'package:otm_inventory/pages/profile/my_account/view/widgets/menu_buttons_grid_widget.dart';
import 'package:otm_inventory/pages/profile/my_account/view/widgets/my_account_bottom_navigation_bar.dart';
import 'package:otm_inventory/pages/profile/my_account/view/widgets/profile_card_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class MyAccountScreen extends StatelessWidget {
  final controller = Get.put(MyAccountController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'my_account'.tr,
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
            ),
            backgroundColor: dashBoardBgColor_(context),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? Center(
                      child: Text("no_internet_text".tr),
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Card
                          ProfileCardWidget(),
                          SizedBox(
                            height: 16,
                          ),
                          // Menu Buttons Grid
                          MenuButtonsGridWidget()
                        ],
                      ),
                    ),
            ),
            bottomNavigationBar: CommonBottomNavigationBarWidget(),
          ),
        )));
  }
}
