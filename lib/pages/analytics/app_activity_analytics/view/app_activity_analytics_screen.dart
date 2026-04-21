import 'package:belcka/pages/analytics/app_activity_analytics/controller/app_activity_analytics_controller.dart';
import 'package:belcka/pages/analytics/app_activity_analytics/view/widgets/app_activity_analytics_grid_view.dart';
import 'package:belcka/pages/analytics/app_activity_analytics/view/widgets/app_activity_analytics_header.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AppActivityAnalyticsScreen extends StatefulWidget {
  const AppActivityAnalyticsScreen({super.key});

  @override
  State<AppActivityAnalyticsScreen> createState() =>
      _AppActivityAnalyticsScreenState();
}

class _AppActivityAnalyticsScreenState extends State<AppActivityAnalyticsScreen>
    implements DateFilterListener {
  final controller = Get.put(AppActivityAnalyticsController());

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
              title: "app_activity".tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: [
                IconButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  onPressed: () {},
                ),
              ],
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.getAppActivityAPI();
                      },
                    )
                  : controller.isMainViewVisible.value
                      ? Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: backgroundColor_(context),
                                boxShadow: [
                                  AppUtils.boxShadow(shadowColor_(context), 10)
                                ],
                                border: Border.all(
                                    width: 0.6, color: Colors.transparent),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(28),
                                  bottomRight: Radius.circular(28),
                                ),
                              ),
                              child: AppActivityAnalyticsHeader(
                                valueText:
                                    "${controller.appActivityScore.value?.score ?? 0}%",
                                progress:
                                    (controller.appActivityScore.value?.score ??
                                            0) /
                                        100,
                                dateRange: controller.dateRange,
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            DateFilterOptionsHorizontalList(
                              padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                              startDate: controller.startDate,
                              endDate: controller.endDate,
                              listener: this,
                              selectedPosition:
                                  controller.selectedDateFilterIndex,
                            ),
                            Expanded(child: AppActivityAnalyticsGridView()),
                          ],
                        )
                      : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onSelectDateFilter(
    int filterIndex,
    String filter,
    String startDate,
    String endDate,
    String dialogIdentifier,
  ) {
    int index = 1;
    if (filter != "Custom" && filter != "Reset") {
      index = filterIndex;
    }
    Get.find<AppStorage>().setTimesheetDateFilterIndex(index);
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getAppActivityAPI();
  }
}
