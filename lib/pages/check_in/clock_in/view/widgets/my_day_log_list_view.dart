import 'package:belcka/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/view/widgets/check_log_list_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/custom_views/dotted_line_vertical_widget.dart';
import 'package:belcka/widgets/shapes/circle_widget.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_constants.dart';

class MyDayLogListView extends StatelessWidget {
  MyDayLogListView({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          // (controller.workLogData.value.workLogInfo ?? []).isNotEmpty &&
          //         ClockInUtils.isCurrentDay(
          //             controller.workLogData.value.workStartDate ?? "")
          (controller.workLogData.value.workLogInfo ?? []).isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    controller: controller.scrollController,
                    itemCount: controller.workLogData.value.workLogInfo!.length,
                    itemBuilder: (context, position) {
                      var info =
                          controller.workLogData.value.workLogInfo![position];
                      return Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                ),
                                // const SizedBox(width: 22),
                                info.id != 0
                                    ? Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 8,
                                              ),
                                              height: 86,
                                              decoration: itemDecoration(
                                                  requestStatus:
                                                      info.requestStatus,
                                                  isWorking:
                                                      isActiveWorkLog(info),
                                                  boxShadow: [
                                                    AppUtils.boxShadow(
                                                        shadowColor_(context),
                                                        6)
                                                  ]),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .onClickWorkLogItem(info);
                                                  // controller.showShiftSummeryDialog();
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      /*Flexible(
                                                flex: 4,
                                                fit: FlexFit.tight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 8, 8, 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      setProjectNameTextView(
                                                          info.shiftName ?? "")
                                                    ],
                                                  ),
                                                ),
                                              ),*/
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            setProjectNameTextView(
                                                                info.shiftName ??
                                                                    ""),
                                                            Visibility(
                                                                visible: !StringHelper
                                                                    .isEmptyString(
                                                                        info.projectName),
                                                                child: SizedBox(
                                                                  height: 6,
                                                                )),
                                                            setProjectNameTextView(
                                                                info.projectName ??
                                                                    "")
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            !StringHelper
                                                                    .isEmptyString(
                                                                        info.workEndTime)
                                                                ? TextViewWithContainer(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12),
                                                                    borderRadius:
                                                                        6,
                                                                    text: !StringHelper.isEmptyString(info
                                                                            .workEndTime)
                                                                        ? DateUtil.seconds_To_HH_MM(
                                                                            info.payableWorkSeconds ??
                                                                                0)
                                                                        : controller
                                                                            .activeWorkHours
                                                                            .value,
                                                                    fontColor: isActiveWorkLog(
                                                                            info)
                                                                        ? Colors
                                                                            .white
                                                                        : primaryTextColor_(
                                                                            context),
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    boxColor: isActiveWorkLog(
                                                                            info)
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .transparent,
                                                                  )
                                                                // SizedBox(
                                                                //   height: 2,
                                                                // ),
                                                                : Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      PrimaryTextView(
                                                                        text:
                                                                            "(${controller.changeFullDateToSortTime(info.workStartTime)}",
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: defaultAccentColor_(
                                                                            context),
                                                                      ),
                                                                      PrimaryTextView(
                                                                        text:
                                                                            " - ",
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: defaultAccentColor_(
                                                                            context),
                                                                      ),
                                                                      PrimaryTextView(
                                                                        text: toWorkTimeText(
                                                                            info),
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: isActiveWorkLog(info)
                                                                            ? defaultAccentColor_(context)
                                                                            : primaryTextColor_(context),
                                                                      )
                                                                    ],
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: CustomBadgeIcon(
                                            //     count: 55,
                                            //   ),
                                            // ),
                                            setItemTypeTextView(
                                                text: 'shift'.tr,
                                                color: "#FF7F00")
                                          ],
                                        ),
                                      )
                                    : emptyView(),
                                SizedBox(
                                  width: 16,
                                )
                              ],
                            ),
                          ),
                          Visibility(
                              visible: (info.userChecklogs ?? []).isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 50, right: 16, bottom: 2),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      bottom: 52,
                                      left: 0,
                                      child: VerticalDivider(
                                        thickness: 1,
                                        width: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 10),
                                      child: CheckLogListView(
                                        parentIndex: position,
                                        isPriceWork: info.isPricework ?? false,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                  ),
                )
              : Container(),
    );
  }

  Widget setProjectNameTextView(String? text) => Visibility(
      visible: !StringHelper.isEmptyString(text),
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 10),
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(
            color:
                ThemeConfig.isDarkMode ? Color(0xFF339CFF) : Color(0xffACDBFE),
            borderRadius: BorderRadius.circular(45)),
        child: PrimaryTextView(
          text: text ?? "",
          fontSize: 13,
          overflow: TextOverflow.ellipsis,
          color: ThemeConfig.isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
          softWrap: false,
          maxLine: 1,
        ),
      ));

  Widget setItemTypeTextView({required String text, required String color}) =>
      Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
              decoration: BoxDecoration(
                  color: Color(AppUtils.haxColor(color)),
                  borderRadius: BorderRadius.circular(45)),
              child: PrimaryTextView(
                text: text ?? "",
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ));

  Widget dottedLine({required int id}) => Column(
        children: [
          Visibility(
            visible: id == 0 &&
                !((controller.workLogData.value.userIsWorking ?? false) &&
                    controller.isChecking.value),
            child: Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: CustomPaint(
                  size: Size(1.3, double.infinity),
                  painter: DottedLineVerticalWidget()),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: id != 0
                ? CustomPaint(
                    size: Size(1.3, double.infinity),
                    painter: DottedLineVerticalWidget())
                : Container(),
          )
        ],
      );

  Widget circle(WorkLogInfo info) => Visibility(
        visible: info.id != 0,
        child: SizedBox(
          width: 22,
          height: 22,
          child: Center(
            child: CircleWidget(
              color:
                  isActiveWorkLog(info) ? Colors.green : Colors.grey.shade400,
              width: 14,
              height: 14,
            ),
          ),
        ),
      );

  Widget addCircle({required int id}) => Visibility(
        visible: id == 0 &&
            !((controller.workLogData.value.userIsWorking ?? false) &&
                controller.isChecking.value),
        child: GestureDetector(
          onTap: () {
            if (!(controller.workLogData.value.userIsWorking ?? false)) {
              controller.onClickStartShiftButton();
            } else {
              // controller
              //     .onClickAddExpense(controller.selectedWorkLogInfo?.id ?? 0);
              var arguments = {
                AppConstants.intentKey.switchProject: true,
                AppConstants.intentKey.workLogId:
                    controller.selectedWorkLogInfo?.id ?? 0,
              };
              controller.onClickStartShiftButton(arguments: arguments);
            }
            // else if ((controller.workLogData.value.userIsWorking ?? false) &&
            //     !controller.isChecking.value) {
            //   controller.onCLickCheckInButton();
            // }
          },
          child: Stack(
            children: [
              CircleWidget(
                  color: dashBoardBgColor_(Get.context!),
                  width: 22,
                  height: 22),
              ImageUtils.setSvgAssetsImage(
                  path: Drawable.addCreateNewPlusIcon,
                  width: 22,
                  height: 22,
                  color: primaryTextColor_(Get.context!))
            ],
          ),
        ),
      );

  Widget emptyView() => Expanded(
        child: SizedBox(
          height: 65,
        ),
      );

  Decoration? itemDecoration(
      {required bool isWorking,
      int? requestStatus,
      double? borderRadius,
      List<BoxShadow>? boxShadow}) {
    return BoxDecoration(
      color: backgroundColor_(Get.context!),
      boxShadow: boxShadow,
      border: Border.all(
          width: 0.9, color: getBorderColor(isWorking, requestStatus)),
      borderRadius: BorderRadius.circular(borderRadius ?? 45),
    );
  }

  Color getBorderColor(bool isWorking, int? requestStatus) {
    if (isWorking) {
      return Color(0xff2DC75C);
    } else {
      if (requestStatus == null || requestStatus == 0) {
        return ThemeConfig.isDarkMode
            ? Color(0xFF1F1F1F)
            : Colors.grey.shade300;
      } else {
        return AppUtils.getStatusColor(requestStatus ?? 0);
      }
    }
  }

  bool isActiveWorkLog(WorkLogInfo info) {
    return StringHelper.isEmptyString(info.workEndTime);
  }

  String toWorkTimeText(WorkLogInfo info) {
    return "${!StringHelper.isEmptyString(info.workEndTime) ? controller.changeFullDateToSortTime(info.workEndTime) : 'ongoing'.tr})";
  }
}
