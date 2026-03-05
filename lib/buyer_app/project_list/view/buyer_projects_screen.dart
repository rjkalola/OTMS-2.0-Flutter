import 'package:belcka/buyer_app/project_list/controller/buyer_projects_controller.dart';
import 'package:belcka/buyer_app/project_list/view/buyer_projects_list.dart';
import 'package:belcka/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BuyerProjectsScreen extends StatelessWidget {
  final controller = Get.put(BuyerProjectsController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(() => Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'projects'.tr,
                isCenterTitle: false,
                bgColor: dashBoardBgColor_(context),
                isBack: true,
                onBackPressed: () {
                  controller.onBackPress();
                },
              ),
              backgroundColor: dashBoardBgColor_(context),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.buyerProjectsListApi(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            BuyerProjectsList()
                          ],
                        ),
                      ),
              ),
              bottomNavigationBar: CommonBottomNavigationBarWidget(),
            ),
          ))),
    );
  }
}
