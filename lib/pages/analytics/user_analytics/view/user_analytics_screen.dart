import 'package:belcka/pages/analytics/user_analytics/controller/user_analytics_controller.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/user_analytics_buttons_grid_widget.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/user_analytics_header_view.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
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

class _UserAnalyticsScreenState extends State<UserAnalyticsScreen> implements DateFilterListener{

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
              title: 'my_analytics'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
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
                    listener: this,
                    selectedPosition: controller.selectedDateFilterIndex,
                  ),
                  SizedBox(height: 16),
                  UserAnalyticsButtonsGridWidget()
                ],
              )
                  : SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDate,
      String endDate, String dialogIdentifier) {
    int index = 1;
    if (filter != "Custom" && filter != "Reset") {
      index = filterIndex;
    }
    Get.find<AppStorage>().setTimesheetDateFilterIndex(index);

    controller.startDate = startDate;
    controller.endDate = endDate;

    if (StringHelper.isEmptyString(startDate) &&
        StringHelper.isEmptyString(endDate)) {
      //controller.appliedFilters = {};
    }
    controller.getUserAnalyticsAPI();
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
