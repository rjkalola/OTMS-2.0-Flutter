import 'package:belcka/pages/check_in/penalty/penalty_list/controller/penalty_list_controller.dart';
import 'package:belcka/pages/check_in/penalty/penalty_list/view/widgets/penalty_list.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PenaltyListScreen extends StatefulWidget {
  const PenaltyListScreen({super.key});

  @override
  State<PenaltyListScreen> createState() => _PenaltyListScreenState();
}

class _PenaltyListScreenState extends State<PenaltyListScreen>
    implements DateFilterListener {
  final controller = Get.put(PenaltyListController());

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
              title: 'penalty'.tr,
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
              // widgets: actionButtons(),
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.getPenaltyListApi(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            // DateFilterOptionsHorizontalList(
                            //   padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                            //   startDate: controller.startDate,
                            //   endDate: controller.endDate,
                            //   listener: this,
                            //   selectedPosition:
                            //       controller.selectedDateFilterIndex,
                            // ),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            PenaltyList(),
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
  void onSelectDateFilter(
      int filterIndex, String filter,String startDate, String endDate, String dialogIdentifier) {
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getPenaltyListApi(true);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
