import 'package:belcka/pages/check_in/check_out/view/widgets/check_in_out_display_note_widget.dart';
import 'package:belcka/pages/check_in/penalty/penalty_details/contoller/penalty_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/buttons/approve_reject_buttons.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/reusable/add_note_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PenaltyDetailsScreen extends StatefulWidget {
  const PenaltyDetailsScreen({super.key});

  @override
  State<PenaltyDetailsScreen> createState() => _PenaltyDetailsScreenState();
}

class _PenaltyDetailsScreenState extends State<PenaltyDetailsScreen> {
  final controller = Get.put(PenaltyDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    // int status = controller.penaltyInfo.value.status ?? 0;
    // print("status:" + status.toString());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(
        () => Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'penalty'.tr,
                isCenterTitle: false,
                isBack: true,
                bgColor: dashBoardBgColor_(context),
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
                            controller.isInternetNotAvailable.value = false;
                            // controller.getTeamListApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CardViewDashboardItem(
                                      margin: const EdgeInsets.fromLTRB(
                                          14, 10, 14, 10),
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 12, 16, 12),
                                      borderRadius: 15,
                                      child: GestureDetector(
                                        onTap: () {
                                          /*if (status == 0 ||
                            status == AppConstants.status.approved) {
                                                    var arguments = {
                            AppConstants.intentKey.leaveInfo: info,
                            AppConstants.intentKey.userId: controller.userId,
                                                    };
                                                    controller.moveToScreen(
                              AppRoutes.createLeaveScreen, arguments);
                                                  } else {
                                                    var arguments = {
                            AppConstants.intentKey.leaveId: info.id ?? 0,
                                                    };
                                                    controller.moveToScreen(
                              AppRoutes.leaveDetailsScreen, arguments);
                                                  }*/
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TitleTextView(
                                                          text: 'start_time'.tr,
                                                          fontSize: 17,
                                                        ),
                                                        TitleTextView(
                                                          text: controller
                                                                  .penaltyInfo
                                                                  .value
                                                                  .startTime ??
                                                              "",
                                                          fontSize: 17,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TitleTextView(
                                                          text: 'end_time'.tr,
                                                          fontSize: 17,
                                                        ),
                                                        TitleTextView(
                                                          text: controller
                                                                  .penaltyInfo
                                                                  .value
                                                                  .endTime ??
                                                              "",
                                                          fontSize: 17,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        TitleTextView(
                                                          text: 'total'.tr,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        TitleTextView(
                                                          text: DateUtil
                                                              .seconds_To_HH_MM(
                                                                  controller
                                                                          .penaltyInfo
                                                                          .value
                                                                          .payableSeconds ??
                                                                      0),
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Divider(
                                                color: dividerColor_(context),
                                                thickness: 1,
                                              ),
                                              TitleTextView(
                                                text:
                                                    "${controller.penaltyInfo.value.penaltyType}: -${DateUtil.seconds_To_HH_MM(controller.penaltyInfo.value.penaltySeconds ?? 0)}",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !StringHelper.isEmptyString(
                                          AppUtils.getStatusText(
                                              controller.status.value)),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: TextViewWithContainer(
                                          margin: EdgeInsets.only(
                                              right: 34, top: 2),
                                          text: AppUtils.getStatusText(
                                              controller.status.value),
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          fontColor: Colors.white,
                                          fontSize: 11,
                                          boxColor: AppUtils.getStatusColor(
                                              controller.status.value),
                                          borderRadius: 5,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Visibility(
                                  visible: controller.status.value != 0,
                                  child: CheckInOutDisplayNoteWidget(
                                    padding: EdgeInsets.fromLTRB(16, 9, 16, 9),
                                    note: controller
                                            .penaltyInfo.value.appealNote ??
                                        "",
                                    labelText: 'appeal_note'.tr,
                                  ),
                                ),
                                Visibility(
                                  visible: controller.status.value ==
                                          AppConstants.status.approved ||
                                      controller.status.value ==
                                          AppConstants.status.rejected,
                                  child: CheckInOutDisplayNoteWidget(
                                    padding: EdgeInsets.fromLTRB(16, 9, 16, 9),
                                    note: controller
                                            .penaltyInfo.value.adminNote ??
                                        "",
                                    labelText: controller.status.value ==
                                            AppConstants.status.approved
                                        ? 'approved_note'.tr
                                        : 'rejected_note'.tr,
                                  ),
                                ),
                                Spacer(),
                                Visibility(
                                  visible: (controller.penaltyStatus.value !=
                                              AppConstants.status.lock &&
                                          controller.penaltyStatus.value !=
                                              AppConstants.status.markAsPaid) &&
                                      ((!UserUtils.isAdmin() &&
                                              controller.status.value == 0) ||
                                          (UserUtils.isAdmin() &&
                                              controller.status.value ==
                                                  AppConstants
                                                      .status.pending) ||
                                          (!UserUtils.isAdmin() &&
                                              controller.status.value ==
                                                  AppConstants
                                                      .status.rejected)),
                                  child: AddNoteWidget(
                                    controller: controller.noteController,
                                    borderRadius: 15,
                                    padding: EdgeInsets.all(16),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(14),
                                  child: footerButtonsView(),
                                )
                              ],
                            ),
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }

  Widget footerButtonsView() {
    if (controller.penaltyStatus.value != AppConstants.status.lock &&
        controller.penaltyStatus.value != AppConstants.status.markAsPaid) {
      if (controller.status.value == 0 ||
          controller.status.value == AppConstants.status.rejected) {
        if (UserUtils.isAdmin()) {
          return removePenaltyButton();
        } else {
          return appealButton();
        }
      } else if (controller.status.value == AppConstants.status.pending) {
        if (UserUtils.isAdmin()) {
          return approveRejectButton();
        } else {
          return requestedView();
        }
        return removePenaltyButton();
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget approveRejectButton() {
    return ApproveRejectButtons(
        // padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
        onClickApprove: () => {
              controller.showActionDialog(AppConstants.dialogIdentifier.approve)
            },
        onClickReject: () {
          if (!StringHelper.isEmptyEdittext(
              controller.noteController.value.text)) {
            controller.showActionDialog(AppConstants.dialogIdentifier.reject);
          } else {
            AppUtils.showToastMessage('enter_note'.tr);
          }
        });
  }

  Widget removePenaltyButton() {
    return PrimaryButton(
        buttonText: 'delete'.tr,
        color: Colors.red,
        onPressed: () {
          controller.showActionDialog(AppConstants.dialogIdentifier.delete);
        });
  }

  Widget requestedView() {
    return TextViewWithContainer(
      width: double.infinity,
      text: 'requested'.tr,
      fontColor: secondaryExtraLightTextColor_(context),
      borderColor: secondaryExtraLightTextColor_(context),
      borderRadius: 45,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
    );
  }

  Widget appealButton() {
    return PrimaryButton(
        buttonText: 'appeal'.tr,
        onPressed: () {
          if (!StringHelper.isEmptyEdittext(
              controller.noteController.value.text)) {
            controller.showActionDialog(AppConstants.dialogIdentifier.appeal);
          } else {
            AppUtils.showToastMessage('enter_note'.tr);
          }
        });
  }
}
