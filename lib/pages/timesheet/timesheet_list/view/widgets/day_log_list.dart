import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';
import 'package:belcka/pages/expense/add_expense/model/expense_info.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/day_log_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class DayLogList extends StatelessWidget {
  DayLogList(
      {super.key, required this.parentPosition, required this.weekPosition});

  final controller = Get.put(TimeSheetListController());
  final int parentPosition, weekPosition;

  @override
  Widget build(BuildContext context) {
    int userId = controller.timeSheetList[parentPosition].userId ?? 0;
    bool showRate = false;
    if (UserUtils.getLoginUserId() == userId) {
      showRate = true;
    } else {
      showRate = controller.showRate.value;
    }

    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          DayLogInfo info = controller.timeSheetList[parentPosition]
              .weekLogs![weekPosition].dayLogs![position];
          String type = (info.type ?? "").toLowerCase();
          // return (info.type ?? "") == "leave"
          //     ? leaveItem(info)
          //     : timeSheetItem(info);

          if (type == "leave") {
            return leaveItem(info);
          } else if (type == "expense") {
            return expenseItem(info, showRate);
          } else if (type == "penalty") {
            return penaltyItem(info);
          } else {
            return timeSheetItem(info, showRate);
          }
        },
        itemCount: controller.timeSheetList[parentPosition]
            .weekLogs![weekPosition].dayLogs!.length,
        // separatorBuilder: (context, position) => const Padding(
        //   padding: EdgeInsets.only(left: 100),
        //   child: Divider(
        //     height: 0,
        //     color: dividerColor,
        //     thickness: 0.8,
        //   ),
        // ),
        separatorBuilder: (context, position) => Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Divider(
                height: 0,
                color: dividerColor_(context),
              ),
            ));
  }

  // Widget dayDate(DayLogInfo info) => CardViewDashboardItem(
  //       borderRadius: 15,
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
  //         child: SizedBox(
  //           width: 50,
  //           child: Column(
  //             children: [
  //               TitleTextView(
  //                 text: info.dayDateInt,
  //                 fontSize: 14,
  //               ),
  //               TitleTextView(
  //                 text: info.day,
  //                 fontSize: 14,
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     );

  Widget dayDate(DayLogInfo info) {
    int status = info.status ?? 0;
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CardViewDashboardItem(
              borderRadius: 15,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: SizedBox(
                  width: 50,
                  height: 46,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TitleTextView(
                        text: info.dayDateInt,
                        fontSize: 14,
                      ),
                      TitleTextView(
                        text: info.day,
                        fontSize: 14,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Visibility(
              visible: status == AppConstants.status.lock ||
                  status == AppConstants.status.unlock ||
                  status == AppConstants.status.markAsPaid,
              child: Container(
                width: 22,
                height: 22,
                decoration: AppUtils.circleDecoration(
                    color: dashBoardBgColor_(Get.context!),
                    borderWidth: 0,
                    borderColor: primaryTextColor_(Get.context!)),
                child: controller.buildStatusIcon(status),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget shiftName(String? title, Color color, {Color? fontColor}) =>
      TextViewWithContainer(
        text: title ?? "",
        padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
        fontColor:
            fontColor ?? (ThemeConfig.isDarkMode ? Colors.white : Colors.black),
        fontSize: 15,
        boxColor: color,
        borderRadius: 5,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget totalWorkHour(DayLogInfo info, bool showRate) => Column(
        children: [
          Visibility(
            visible: showRate,
            child: TitleTextView(
              text: ((info.isPricework ?? false))
                  ? "£${info.priceWorkTotalAmount ?? "0"}"
                  : (controller.isViewAmount.value
                      ? "£${info.payableAmount ?? "0"}"
                      : DateUtil.seconds_To_HH_MM(
                          info.payableWorkSeconds ?? 0)),
              color: info.requestStatus != null
                  ? AppUtils.getStatusColor(info.requestStatus ?? 0)
                  : primaryTextColor_(Get.context!),
              fontSize: 17,
            ),
          ),
          SubtitleTextView(
            text: "(${info.startTimeFormat} - ${info.endTimeFormat})",
            fontSize: 13,
          )
        ],
      );

  // String getDayLogAmountToDisplay(DayLogInfo info) {
  //   String value = "";
  //   if (controller.isViewAmount.value) {
  //     if ((info.isPricework ?? false)) {
  //       value = "£${info.priceWorkTotalAmount ?? "0"}";
  //     } else {
  //       value = "£${info.payableAmount ?? "0"}";
  //     }
  //   } else {
  //     if ((info.isPricework ?? false)) {
  //       value = "£${info.priceWorkTotalAmount ?? "0"}";
  //     } else {
  //       value = DateUtil.seconds_To_HH_MM(info.payableWorkSeconds ?? 0);
  //     }
  //   }
  //   return "";
  // }

  Widget timeSheetItem(DayLogInfo info, bool showRate) => Obx(
        () => Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  controller.isEditEnable.value ? 0 : 10, 12, 13, 12),
              child: GestureDetector(
                onTap: () {
                  if (!controller.isEditEnable.value &&
                      !controller.isEditStatusEnable.value) {
                    controller.onClickWorkLogItem(info.id ?? 0,
                        controller.timeSheetList[parentPosition].userId ?? 0);
                  } else {
                    if (controller.isEditEnable.value) {
                      info.isCheck = !(info.isCheck ?? false);
                      controller.timeSheetList.refresh();
                    }
                  }
                  controller.checkSelectAll();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Visibility(
                        visible: controller.isEditEnable.value,
                        child: CustomCheckbox(
                            onValueChange: (value) {
                              info.isCheck = !(info.isCheck ?? false);
                              controller.timeSheetList.refresh();
                              controller.checkSelectAll();
                            },
                            mValue: info.isCheck ?? false),
                      ),
                      dayDate(info),
                      SizedBox(
                        width: 4,
                      ),
                      SizedBox(
                        width: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shiftName(
                                info.shiftName,
                                ThemeConfig.isDarkMode
                                    ? Color(0xFF4BA0F3)
                                    : Color(0xffACDBFE))
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      totalWorkHour(info, showRate),
                      SizedBox(
                        width: 4,
                      ),
                      RightArrowWidget(
                        color: primaryTextColor_(Get.context!),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: (info.userCheckLogsCount ?? 0) != 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 6),
                  child: CustomBadgeIcon(
                    count: info.userCheckLogsCount ?? 0,
                    color: defaultAccentColor_(Get.context!),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  // Widget timeSheetItem(DayLogInfo info) => Obx(
  //       () => Stack(
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.fromLTRB(
  //                 controller.isEditEnable.value ? 0 : 10, 12, 13, 12),
  //             child: GestureDetector(
  //               onTap: () {
  //                 if (!controller.isEditEnable.value &&
  //                     !controller.isEditStatusEnable.value) {
  //                   controller.onClickWorkLogItem(info.id ?? 0,
  //                       controller.timeSheetList[parentPosition].userId ?? 0);
  //                 } else {
  //                   if (controller.isEditEnable.value) {
  //                     info.isCheck = !(info.isCheck ?? false);
  //                     controller.timeSheetList.refresh();
  //                   }
  //                 }
  //                 controller.checkSelectAll();
  //               },
  //               child: Container(
  //                 color: Colors.transparent,
  //                 child: Row(
  //                   children: [
  //                     Visibility(
  //                       visible: controller.isEditEnable.value,
  //                       child: CustomCheckbox(
  //                           onValueChange: (value) {
  //                             info.isCheck = !(info.isCheck ?? false);
  //                             controller.timeSheetList.refresh();
  //                             controller.checkSelectAll();
  //                           },
  //                           mValue: info.isCheck ?? false),
  //                     ),
  //                     dayDate(info),
  //                     SizedBox(
  //                       width: 4,
  //                     ),
  //                     Expanded(
  //                       child: Row(
  //                         children: [
  //                           Flexible(
  //                               fit: FlexFit.tight,
  //                               flex: 5,
  //                               child: shiftName(
  //                                   info.shiftName,
  //                                   ThemeConfig.isDarkMode
  //                                       ? Color(0xFF4BA0F3)
  //                                       : Color(0xffACDBFE))),
  //                           Flexible(
  //                               fit: FlexFit.tight,
  //                               flex: 6,
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   // Expanded(child: Container()),
  //                                   totalWorkHour(info),
  //                                   SizedBox(
  //                                     width: 4,
  //                                   ),
  //                                   RightArrowWidget(
  //                                     color: primaryTextColor_(Get.context!),
  //                                   )
  //                                 ],
  //                               ))
  //                         ],
  //                       ),
  //                     ),
  //                     // Expanded(child: Container()),
  //                     // totalWorkHour(info),
  //                     // SizedBox(
  //                     //   width: 4,
  //                     // ),
  //                     // RightArrowWidget(
  //                     //   color: primaryTextColor_(Get.context!),
  //                     // )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Align(
  //             alignment: Alignment.topRight,
  //             child: Visibility(
  //               visible: (info.userCheckLogsCount ?? 0) != 0,
  //               child: Padding(
  //                 padding: const EdgeInsets.only(right: 16, top: 6),
  //                 child: CustomBadgeIcon(
  //                   count: info.userCheckLogsCount ?? 0,
  //                   color: defaultAccentColor_(Get.context!),
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     );

  Widget leaveItem(DayLogInfo info) {
    LeaveInfo? leaveInfo = info.leaveInfo;
    return leaveInfo != null
        ? Padding(
            padding: EdgeInsets.fromLTRB(10, 12, 13, 12),
            child: GestureDetector(
              onTap: () {
                int status = leaveInfo.requestStatus ?? 0;
                if (status == 0 || status == AppConstants.status.approved) {
                  var arguments = {
                    AppConstants.intentKey.leaveInfo: leaveInfo,
                    AppConstants.intentKey.userId: leaveInfo.userId ?? 0,
                  };
                  controller.moveToScreen(
                      AppRoutes.createLeaveScreen, arguments);
                } else {
                  var arguments = {
                    AppConstants.intentKey.leaveId: leaveInfo.id ?? 0,
                  };
                  controller.moveToScreen(
                      AppRoutes.leaveDetailsScreen, arguments);
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    dayDate(info),
                    SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextView(
                            text: leaveInfo.leaveName ?? "",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          shiftName(
                              'leave'.tr, Colors.red.withValues(alpha: 0.4))
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        TitleTextView(
                          text: StringHelper.capitalizeFirstLetter(
                              leaveInfo.leaveType ?? ""),
                          color: leaveInfo.requestStatus != null
                              ? AppUtils.getStatusColor(
                                  leaveInfo.requestStatus ?? 0)
                              : primaryTextColor_(Get.context!),
                          fontSize: 17,
                        ),
                        !(leaveInfo.isAlldayLeave ?? false)
                            ? SubtitleTextView(
                                text:
                                    "(${leaveInfo.startTime} - ${leaveInfo.endTime})",
                                fontSize: 13,
                              )
                            : SizedBox(
                                height: 1,
                                child: SubtitleTextView(
                                  text: "00:00 - 00:00",
                                  fontSize: 13,
                                  color: Colors.transparent,
                                ),
                              )
                      ],
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    RightArrowWidget(
                      color: primaryTextColor_(Get.context!),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Widget expenseItem(DayLogInfo info, bool showRate) {
    ExpenseInfo? expenseInfo = info.expenseInfo;
    return expenseInfo != null
        ? Padding(
            padding: EdgeInsets.fromLTRB(10, 12, 13, 12),
            child: GestureDetector(
              onTap: () {
                if (showRate) {
                  var arguments = {
                    AppConstants.intentKey.expenseId: expenseInfo.id ?? 0,
                  };
                  controller.moveToScreen(
                      AppRoutes.addExpenseScreen, arguments);
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    dayDate(info),
                    SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextView(
                            text: expenseInfo.projectName ?? "",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          shiftName('expenses'.tr,
                              Colors.green.withValues(alpha: 0.4))
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        Visibility(
                          visible: showRate,
                          child: TitleTextView(
                            text:
                                "${expenseInfo.currency ?? ""}${expenseInfo.totalAmount ?? 0}",
                            color: expenseInfo.requestStatus != null
                                ? AppUtils.getStatusColor(
                                    expenseInfo.requestStatus ?? 0)
                                : primaryTextColor_(Get.context!),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 1,
                          child: SubtitleTextView(
                            text: "00:00 - 00:00",
                            fontSize: 13,
                            color: Colors.transparent,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    RightArrowWidget(
                      color: primaryTextColor_(Get.context!),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Widget penaltyItem(DayLogInfo info) {
    PenaltyInfo? penaltyInfo = info.penaltyInfo;
    return penaltyInfo != null
        ? Obx(
            () => Padding(
              padding: EdgeInsets.fromLTRB(10, 12, 13, 12),
              child: GestureDetector(
                onTap: () {
                  // var arguments = {
                  //   AppConstants.intentKey.expenseId: penaltyInfo.id ?? 0,
                  // };
                  // controller.moveToScreen(AppRoutes.addExpenseScreen, arguments);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      dayDate(info),
                      SizedBox(
                        width: 4,
                      ),
                      SizedBox(
                        width: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleTextView(
                              text: penaltyInfo.penaltyType ?? "",
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            shiftName('penalty'.tr, Colors.red,
                                fontColor: Colors.white)
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Column(
                        children: [
                          TitleTextView(
                            text: controller.isViewAmount.value
                                ? "£${penaltyInfo.penaltyAmount ?? "0"}"
                                : "-${DateUtil.seconds_To_HH_MM(penaltyInfo.penaltySeconds ?? 0)}",
                            color: Colors.red,
                            fontSize: 17,
                          ),
                          SizedBox(
                            height: 1,
                            child: SubtitleTextView(
                              text: "00:00 - 00:00",
                              fontSize: 13,
                              color: Colors.transparent,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      RightArrowWidget(
                        color: primaryTextColor_(Get.context!),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
