import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_with_all_horizontal_list.dart';
import 'package:belcka/pages/leaves/leave_list/controller/leave_list_controller.dart';
import 'package:belcka/pages/leaves/leave_list/view/widgets/leave_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({super.key});

  @override
  State<LeaveListScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen>
    implements DateFilterListener {
  final controller = Get.put(LeaveListController());

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
              title: 'leaves'.tr,
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
              widgets: actionButtons(),
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.getLeaveListApi(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            controller.userId != 0
                                ? DateFilterOptionsWithAllHorizontalList(
                                    padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                                    startDate: controller.startDate,
                                    endDate: controller.endDate,
                                    listener: this,
                                    selectedPosition:
                                        controller.selectedDateFilterIndex,
                                  )
                                : DateFilterOptionsHorizontalList(
                                    padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                                    startDate: controller.startDate,
                                    endDate: controller.endDate,
                                    listener: this,
                                    selectedPosition:
                                        controller.selectedDateFilterIndex,
                                  ),
                            SizedBox(
                              height: 15,
                            ),
                            LeaveList(),
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      IconButton(
        icon: Icon(Icons.more_vert_outlined),
        onPressed: () {
          controller.showMenuItemsDialog(Get.context!);
        },
      )
    ];
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDate,
      String endDate, String dialogIdentifier) {
    if (filter == "All") {
      controller.isAllLeaves.value = true;
    } else {
      controller.isAllLeaves.value = false;
    }

    print("Filter:" + filter);
    print("controller.isAllLeaves.value:" +
        controller.isAllLeaves.value.toString());

    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getLeaveListApi(true);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
