import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/add_note_widget.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/break_log_list.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/start_stop_box_row.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/stop_shift_button.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/submit_for_approval_button.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/total_hours_row.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/map_view/bottom_curve_container.dart';
import 'package:otm_inventory/widgets/map_view/custom_map_view.dart';
import 'package:otm_inventory/widgets/map_view/map_back_arrow.dart';
import 'package:otm_inventory/widgets/other_widgets/selection_screen_header_view.dart';

class StopShiftScreen extends StatefulWidget {
  const StopShiftScreen({super.key});

  @override
  State<StopShiftScreen> createState() => _StopShiftScreenState();
}

class _StopShiftScreenState extends State<StopShiftScreen> {
  final controller = Get.put(StopShiftController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
            child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          /* appBar: BaseAppBar(
            appBar: AppBar(),
            title:
                controller.isWorking.value ? 'my_shift'.tr : 'edit_my_shift'.tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
          ),*/
          body: Obx(
            () => ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Visibility(
                visible: controller.isMainViewVisible.value,
                child: Column(children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CustomMapView(
                          onMapCreated: controller.onMapCreated,
                          target: controller.center,
                          markers: controller.markers,
                          polylines: controller.polylines,
                        ),
                        MapBackArrow(onBackPressed: () {
                          controller.onBackPress();
                        }),
                        BottomCurveContainer()
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SelectionScreenHeaderView(
                          title: controller.isWorking.value
                              ? 'my_shift'.tr
                              : 'edit_my_shift'.tr,
                          userCheckLogCount:
                              controller.workLogInfo.value.userCheckLogsCount ??
                                  0,
                          onBackPressed: () {
                            controller.onBackPress();
                          },
                          onCheckLogCountClick: () {
                            var arguments = {
                              AppConstants.intentKey.workLogId:
                              controller.workLogId
                            };
                            Get.toNamed(AppRoutes.checkLogDetailsScreen,
                                arguments: arguments);
                            print("onCheckLogCountClick");
                          },
                        ),
                        StartStopBoxRow(),
                        BreakLogList(
                            breakLogList:
                                controller.workLogInfo.value.breakLog ?? []),
                        TotalHoursRow(),
                        Visibility(
                            visible: controller.isEdited.value,
                            child: AddNoteWidget(
                                controller: controller.noteController)),
                        controller.isWorking.value
                            ? StopShiftButton()
                            : Visibility(
                                visible: controller.isEdited.value,
                                child: SubmitForApprovalButton(),
                              )
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
