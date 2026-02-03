import 'package:belcka/pages/leaves/leave_details/controller/leave_details_controller.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/add_note_widget.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/all_day_off_view.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/all_day_on_view.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/all_day_widget.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/leave_note.dart';
import 'package:belcka/pages/leaves/leave_details/view/widgets/total_time_requested.dart';
import 'package:belcka/pages/leaves/leave_utils.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/buttons/approve_reject_buttons.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LeaveDetailsScreen extends StatefulWidget {
  const LeaveDetailsScreen({super.key});

  @override
  State<LeaveDetailsScreen> createState() => _LeaveDetailsScreenState();
}

class _LeaveDetailsScreenState extends State<LeaveDetailsScreen> {
  final controller = Get.put(LeaveDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => PopScope(
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
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: controller.title.value,
                isCenterTitle: false,
                isBack: false,
                bgColor: dashBoardBgColor_(context),
                widgets: actionButtons(),
                onBackPressed: () {
                  controller.onBackPress();
                },
              ),
              body: ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? NoInternetWidget(
                          onPressed: () {
                            // controller.isInternetNotAvailable.value = false;
                            // controller.getTeamListApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 14),
                                        child: Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            DropDownTextField(
                                              title: 'leave_type'.tr,
                                              controller: controller
                                                  .leaveTypeController,
                                              isReadOnly: true,
                                              // isEnabled: false,
                                              isArrowHide: true,
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      16, 14, 80, 14),
                                              validators: [
                                                RequiredValidator(
                                                    errorText:
                                                        'required_field'.tr),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 26),
                                              child: TitleTextView(
                                                text:
                                                    controller.leaveType.value,
                                                color: LeaveUtils
                                                    .getLeaveTypeColor(
                                                        controller
                                                            .leaveType.value),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      divider(),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      AllDayWidget(),
                                      AllDayOnView(),
                                      AllDayOffView(),
                                      divider(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TotalTimeRequested(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      divider(),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      LeaveNote(
                                        controller: controller.noteController,
                                        onValueChange: (value) {
                                          controller.isSaveEnable.value =
                                              !StringHelper.isEmptyString(
                                                  value);
                                        },
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible:
                                    (controller.leaveInfo.value.isRequested ??
                                            false) &&
                                        UserUtils.isAdmin(),
                                child: AddNoteWidget(
                                  controller: controller.requestNoteController,
                                ),
                              ),
                              Visibility(
                                  visible:
                                      controller.leaveInfo.value.isRequested ??
                                          false,
                                  child: UserUtils.isAdmin()
                                      ? ApproveRejectButtons(
                                          padding: EdgeInsets.fromLTRB(
                                              14, 8, 14, 16),
                                          onClickReject: () {
                                            if (!StringHelper.isEmptyString(
                                                controller.requestNoteController
                                                    .value.text)) {
                                              controller.showActionDialog(
                                                  AppConstants
                                                      .dialogIdentifier.reject);
                                            } else {
                                              AppUtils.showToastMessage(
                                                  'empty_note_error'.tr);
                                            }
                                          },
                                          onClickApprove: () {
                                            controller.showActionDialog(
                                                AppConstants
                                                    .dialogIdentifier.approve);
                                          })
                                      : TextViewWithContainer(
                                          margin: EdgeInsets.all(14),
                                          width: double.infinity,
                                          height: 44,
                                          borderRadius: 45,
                                          borderColor: AppUtils.getStatusColor(
                                              controller.requestStatus.value),
                                          boxColor: Colors.transparent,
                                          text: AppUtils.getStatusText(
                                              controller.requestStatus.value),
                                          fontColor: AppUtils.getStatusColor(
                                              controller.requestStatus.value),
                                          fontWeight: FontWeight.w400,
                                          alignment: Alignment.center,
                                        )),
                              Visibility(
                                visible: controller.requestStatus.value ==
                                        AppConstants.status.approved ||
                                    controller.requestStatus.value ==
                                        AppConstants.status.rejected,
                                child: TextViewWithContainer(
                                  margin: EdgeInsets.all(14),
                                  width: double.infinity,
                                  height: 44,
                                  borderRadius: 45,
                                  borderColor: AppUtils.getStatusColor(
                                      controller.requestStatus.value),
                                  boxColor: Colors.transparent,
                                  text: AppUtils.getStatusText(
                                      controller.requestStatus.value),
                                  fontColor: AppUtils.getStatusColor(
                                      controller.requestStatus.value),
                                  fontWeight: FontWeight.w400,
                                  alignment: Alignment.center,
                                ),
                              )
                            ],
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Divider(
          height: 0,
        ),
      );

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: !controller.isFromNotification.value &&
            !controller.isFromRequest.value &&
            controller.isMainViewVisible.value,
        child: TextButton(
            onPressed: () {
              controller.showRemoveLeaveDialog();
            },
            child: TitleTextView(
              text: 'delete'.tr,
              color: Colors.red,
            )),
      ),
    ];
  }
}
