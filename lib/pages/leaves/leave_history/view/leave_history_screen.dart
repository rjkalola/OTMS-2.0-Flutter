import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/leaves/leave_history/controller/leave_history_controller.dart';
import 'package:belcka/pages/leaves/leave_history/view/widgets/leave_history_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LeaveHistoryScreen extends StatefulWidget {
  const LeaveHistoryScreen({super.key});

  @override
  State<LeaveHistoryScreen> createState() => _LeaveHistoryScreenState();
}

class _LeaveHistoryScreenState extends State<LeaveHistoryScreen>
    implements DateFilterListener {
  final controller = Get.put(LeaveHistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'leave_history'.tr,
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.getLeaveHistory(true);
                      },
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Column(
                        children: [
                          DateFilterOptionsHorizontalList(
                            padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                            startDate: controller.startDate,
                            endDate: controller.endDate,
                            listener: this,
                            selectedPosition:
                                controller.selectedDateFilterIndex,
                          ),
                          Expanded(
                            child: LeaveHistoryList(),
                          ),
                        ],
                      ),
                    ),
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
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getLeaveHistory(true);
  }
}
