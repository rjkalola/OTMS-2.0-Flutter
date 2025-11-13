import 'package:belcka/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:belcka/pages/profile/my_account/controller/my_account_controller.dart';
import 'package:belcka/pages/profile/my_account/view/widgets/menu_buttons_grid_widget.dart';
import 'package:belcka/pages/profile/my_account/view/widgets/profile_card_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
              title: UserUtils.isLoginUser(controller.userId)
                  ? 'my_account'.tr
                  : '',
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
                          MenuButtonsGridWidget(),
                          Visibility(
                            visible: !UserUtils.isLoginUser(controller.userId),
                            child: PrimaryBorderButton(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 30),
                              buttonText: 'remove_user'.tr,
                              fontColor: Colors.red,
                              fontSize: 16,
                              onPressed: () {
                                controller.showRemoveUserOptionDialog();
                              },
                              borderColor: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
            ),
            bottomNavigationBar: CommonBottomNavigationBarWidget(),
          ),
        )));
  }
}
