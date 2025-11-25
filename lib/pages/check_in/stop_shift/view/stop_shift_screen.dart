import 'package:belcka/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/add_note_widget.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/break_log_list.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/check_in_hours_row.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/current_log_summery.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/penalty_hours_row.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/pending_request_time_box.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/start_stop_box_row.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/stop_shift_button.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/submit_for_approval_button.dart';
import 'package:belcka/pages/check_in/stop_shift/view/widgets/total_hours_row.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/map_view/bottom_curve_container.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
import 'package:belcka/widgets/map_view/map_back_arrow.dart';
import 'package:belcka/widgets/other_widgets/selection_screen_header_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
                    flex: 4,
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
                        BottomCurveContainer(),
                        Visibility(
                          visible: (controller
                                      .workLogInfo.value.userCheckLogsCount ??
                                  0) !=
                              0,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 12, 24),
                              child: PrimaryButton(
                                  width: 100,
                                  height: 38,
                                  buttonText:
                                      "${'check_in_'.tr} (${controller.workLogInfo.value.userCheckLogsCount ?? 0})",
                                  onPressed: () {
                                    var arguments = {
                                      AppConstants.intentKey.workLogId:
                                          controller.workLogId
                                    };
                                    Get.toNamed(AppRoutes.checkLogDetailsScreen,
                                        arguments: arguments);
                                  }),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SelectionScreenHeaderView(
                            title: controller.isWorking.value
                                ? 'my_shift'.tr
                                : 'edit_my_shift'.tr,
                            // userCheckLogCount:
                            //     controller.workLogInfo.value.userCheckLogsCount ??
                            //         0,
                            userCheckLogCount: 0,
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
                            },
                          ),
                          (controller.workLogInfo.value.requestStatus ?? 0) ==
                                  AppConstants.status.pending
                              ? PendingRequestTimeBox()
                              : StartStopBoxRow(),
                          BreakLogList(
                              breakLogList:
                                  controller.workLogInfo.value.breakLog ?? []),
                          TotalHoursRow(),
                          Visibility(
                              visible: controller.isEdited.value,
                              child: AddNoteWidget(
                                  controller: controller.noteController)),

                          // PenaltyHoursRow(),
                          // CheckInHoursRow(),
                          CurrentLogSummery(),
                        ],
                      ),
                    ),
                  ),
                  controller.isWorking.value
                      ? StopShiftButton()
                      : Visibility(
                    visible: controller.isEdited.value,
                    child: SubmitForApprovalButton(),
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
