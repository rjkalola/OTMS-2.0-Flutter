import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/check_in/work_log_request/controller/work_log_request_controller.dart';
import 'package:belcka/pages/check_in/work_log_request/view/widgets/add_note_widget.dart';
import 'package:belcka/pages/check_in/work_log_request/view/widgets/approve_reject_buttons.dart';
import 'package:belcka/pages/check_in/work_log_request/view/widgets/break_log_list.dart';
import 'package:belcka/pages/check_in/work_log_request/view/widgets/display_note_widget.dart';
import 'package:belcka/pages/check_in/work_log_request/view/widgets/start_stop_box_row.dart';
import 'package:belcka/pages/check_in/work_log_request/view/widgets/total_hours_row.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/map_view/bottom_curve_container.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
import 'package:belcka/widgets/map_view/map_back_arrow.dart';
import 'package:belcka/widgets/other_widgets/selection_screen_header_view.dart';

class WorkLogRequestScreen extends StatefulWidget {
  const WorkLogRequestScreen({super.key});

  @override
  State<WorkLogRequestScreen> createState() => _WorkLogRequestScreenState();
}

class _WorkLogRequestScreenState extends State<WorkLogRequestScreen> {
  final controller = Get.put(WorkLogRequestController());

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
            () => Stack(
              children: [
                ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: Form(
                    key: controller.formKey,
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
                      Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SelectionScreenHeaderView(
                                  title: 'my_shift'.tr,
                                  statusText:
                                      StringHelper.capitalizeFirstLetter(
                                          controller.workLogInfo.value
                                                  .statusText ??
                                              ""),
                                  statusColor: AppUtils.getStatusColor(
                                      controller.workLogInfo.value.status ?? 0),
                                  onBackPressed: () {
                                    controller.onBackPress();
                                  },
                                ),
                                StartStopBoxRow(),
                                TotalHoursRow(),
                                BreakLogList(
                                    breakLogList:
                                        controller.workLogInfo.value.breakLog ??
                                            []),
                                DisplayNoteWidget(
                                  isReadOnly: true,
                                  note: controller.workLogInfo.value.note,
                                  status: controller.status,
                                ),
                                Visibility(
                                    visible:
                                        (controller.workLogInfo.value.status ??
                                                    0) ==
                                                AppConstants.status.pending &&
                                            !UserUtils.isLoginUser(controller
                                                .workLogInfo.value.userId),
                                    child: AddNoteWidget(
                                        controller: controller.noteController)),
                                Visibility(
                                  visible:
                                      (controller.workLogInfo.value.status ??
                                                  0) ==
                                              AppConstants.status.pending &&
                                          (!UserUtils.isLoginUser(controller
                                                  .workLogInfo.value.userId) ||
                                              UserUtils.isAdmin()),
                                  child: ApproveRejectButtons(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 10, 12, 18),
                                      onClickApprove: () => {
                                            if (controller.valid())
                                              {
                                                controller.showActionDialog(
                                                    AppConstants
                                                        .dialogIdentifier
                                                        .approve),
                                              }
                                          },
                                      onClickReject: () {
                                        /* String note = StringHelper.getText(
                                            controller.noteController.value);
                                        if (!StringHelper.isEmptyString(note)) {
                                          controller.showActionDialog(AppConstants
                                              .dialogIdentifier.reject);
                                        } else {
                                          AppUtils.showToastMessage(
                                              'empty_note_error'.tr);
                                        }*/

                                        if (controller.valid()) {
                                          controller.showActionDialog(
                                              AppConstants
                                                  .dialogIdentifier.reject);
                                        }
                                      }),
                                )
                              ],
                            ),
                          ))
                    ]),
                  ),
                ),
                // Center(
                //   child: AlertDialog(
                //     title: Text("Are you sure you want to approve?"),
                //     actions: [
                //       TextButton(
                //         onPressed: () {},
                //         child: Text("No"),
                //       ),
                //       TextButton(
                //         onPressed: () {},
                //         child: Text("Yes"),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
