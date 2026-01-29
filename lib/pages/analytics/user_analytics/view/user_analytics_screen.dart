import 'package:belcka/pages/analytics/user_analytics/controller/user_analytics_controller.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/user_analytics_buttons_grid_widget.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/user_analytics_header_view.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserAnalyticsScreen extends StatefulWidget {
  const UserAnalyticsScreen({super.key});
  @override
  State<UserAnalyticsScreen> createState() => _UserAnalyticsScreenState();
}

class _UserAnalyticsScreenState extends State<UserAnalyticsScreen> {

  final controller = Get.put(UserAnalyticsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
              () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'My Analytics'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              autoFocus: true,
              isClearVisible: false.obs,
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                onPressed: () {
                  controller.isInternetNotAvailable.value = false;
                },
              )
                  : controller.isMainViewVisible.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAnalyticsHeaderView(),
                  SizedBox(height: 16),
                  DateFilterOptionsHorizontalList(
                    padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                    startDate: controller.startDate,
                    endDate: controller.endDate,
                    selectedPosition: controller.selectedDateFilterIndex,
                  ),
                  SizedBox(height: 16),
                  UserAnalyticsButtonsGridWidget()
                ],
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
