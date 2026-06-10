import 'package:belcka/buyer_app/hire_history/controller/hire_history_controller.dart';
import 'package:belcka/buyer_app/hire_history/view/widgets/hire_history_list.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HireHistoryScreen extends StatefulWidget {
  const HireHistoryScreen({super.key});

  @override
  State<HireHistoryScreen> createState() => _HireHistoryScreenState();
}

class _HireHistoryScreenState extends State<HireHistoryScreen>
    implements DateFilterListener {
  final controller = Get.put(HireHistoryController());

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
              title: 'history'.tr,
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
                        controller.getHireHistory(true);
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
                            child: HireHistoryList(),
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
    controller.getHireHistory(true);
  }
}
