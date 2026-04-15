import 'package:belcka/buyer_app/generate_report/controller/generate_report_controller.dart';
import 'package:belcka/buyer_app/generate_report/view/generate_report_items_list.dart';
import 'package:belcka/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../utils/app_utils.dart';

class GenerateReportScreen extends StatelessWidget {
  GenerateReportScreen({super.key});

  final controller = Get.put(GenerateReportController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(() => Container(
            color: dashBoardBgColor_(context),
            child: SafeArea(
              top: false,
              child: Scaffold(
                appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: 'generate_report'.tr,
                  isCenterTitle: false,
                  bgColor: dashBoardBgColor_(context),
                  isBack: true,
                  onBackPressed: () {
                    controller.onBackPress();
                  },
                ),
                backgroundColor: dashBoardBgColor_(context),
                body: ModalProgressHUD(
                  inAsyncCall:
                      controller.isLoading.value || controller.isExporting.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? Center(
                          child: Text('no_internet_text'.tr),
                        )
                      : !controller.isModulesLoaded
                          ? const SizedBox.shrink()
                          : Column(
                          children: [
                            const SizedBox(height: 8),
                            GenerateReportItemsList(),
                          ],
                        ),
                ),
                bottomNavigationBar: CommonBottomNavigationBarWidget(),
              ),
            ),
          )),
    );
  }
}
