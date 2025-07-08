import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_utils.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_list_response.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/custom_views/dotted_line_vertical_widget.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';

class MyDayLogListView extends StatelessWidget {
  MyDayLogListView({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.workLogData.value.workLogInfo ?? []).isNotEmpty &&
              ClockInUtils.isCurrentDay(
                  controller.workLogData.value.workStartDate ?? "")
          ? Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(), //
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: List.generate(
                  controller.workLogData.value.workLogInfo!.length,
                  (position) {
                    var info =
                        controller.workLogData.value.workLogInfo![position];
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              dottedLine(id: info.id ?? 0),
                              circle(info),
                              addCircle(id: info.id ?? 0)
                            ],
                          ),
                          info.id != 0
                              ? Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 8,
                                            top: 8,
                                            bottom: 10,
                                            right: 3),
                                        height: 80,
                                        decoration: itemDecoration(
                                            isRequestPending:
                                                info.isRequestPending ?? false,
                                            isWorking: isActiveWorkLog(info),
                                            boxShadow: [
                                              AppUtils.boxShadow(
                                                  Colors.grey.shade300, 6)
                                            ]),
                                        child: InkWell(
                                          onTap: () {
                                            controller.onClickWorkLogItem(info);
                                            // controller.showShiftSummeryDialog();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                              setProjectNameTextView(
                                                  info.shiftName ?? ""),
                                              /*  Flexible(
                                                  flex: 4,
                                                  fit: FlexFit.tight,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextViewWithContainer(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12,
                                                                right: 12),
                                                        borderRadius: 6,
                                                        text: !StringHelper
                                                                .isEmptyString(info
                                                                    .workEndTime)
                                                            ? DateUtil
                                                                .seconds_To_HH_MM(
                                                                    info.totalWorkSeconds ??
                                                                        0)
                                                            : "00:00",
                                                        fontSize: 17,
                                                        fontColor: isActiveWorkLog(
                                                                info)
                                                            ? Colors.white
                                                            : primaryTextColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        boxColor:
                                                            isActiveWorkLog(
                                                                    info)
                                                                ? Colors.green
                                                                : Colors
                                                                    .transparent,
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      PrimaryTextView(
                                                        text:
                                                            fromToWorkTimeText(
                                                                info),
                                                        fontSize: 13,
                                                        color: primaryTextColor,
                                                      )
                                                    ],
                                                  )),*/
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextViewWithContainer(
                                                      padding: EdgeInsets.only(
                                                          left: 12, right: 12),
                                                      borderRadius: 6,
                                                      text: !StringHelper
                                                              .isEmptyString(info
                                                                  .workEndTime)
                                                          ? DateUtil
                                                              .seconds_To_HH_MM(
                                                                  info.payableWorkSeconds ??
                                                                      0)
                                                          : "00:00",
                                                      fontSize: 20,
                                                      fontColor:
                                                          isActiveWorkLog(info)
                                                              ? Colors.white
                                                              : primaryTextColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      boxColor:
                                                          isActiveWorkLog(info)
                                                              ? Colors.green
                                                              : Colors
                                                                  .transparent,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    PrimaryTextView(
                                                      text: fromToWorkTimeText(
                                                          info),
                                                      fontSize: 15,
                                                      color: primaryTextColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 45,
                                                height: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
                                                decoration: itemDecoration(
                                                    isRequestPending:
                                                        info.isRequestPending ??
                                                            false,
                                                    isWorking:
                                                        isActiveWorkLog(info),
                                                    borderRadius: 14),
                                                child: Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 28,
                                                ),
                                              )
                                            ],
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
                                          text: 'shift'.tr, color: "#FF7F00")
                                    ],
                                  ),
                                )
                              : emptyView(),
                          SizedBox(
                            width: 16,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          : Container(),
    );
  }

  Widget setProjectNameTextView(String? text) => Container(
        width: 70,
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(
            color: Color(0xffACDBFE), borderRadius: BorderRadius.circular(4)),
        child: PrimaryTextView(
          text: text ?? "",
          fontSize: 14,
          overflow: TextOverflow.ellipsis,
          color: primaryTextColor,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
          softWrap: false,
          maxLine: 1,
        ),
      );

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
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ));

  Widget dottedLine({required int id}) => Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: CustomPaint(
                size: Size(1.3, double.infinity),
                painter: DottedLineVerticalWidget()),
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
        visible: id == 0,
        child: GestureDetector(
          onTap: () {
            if (!(controller.workLogData.value.userIsWorking ?? false)) {
              controller.onClickStartShiftButton();
            }
          },
          child: ImageUtils.setSvgAssetsImage(
              path: Drawable.addCreateNewPlusIcon,
              width: 22,
              height: 22,
              color: primaryTextColor),
        ),
      );

  Widget emptyView() => Expanded(
        child: SizedBox(
          height: 90,
        ),
      );

  Decoration? itemDecoration(
      {required bool isWorking,
      required bool isRequestPending,
      double? borderRadius,
      List<BoxShadow>? boxShadow}) {
    return BoxDecoration(
      color: backgroundColor,
      boxShadow: boxShadow,
      border: Border.all(
          width: 0.9, color: getBorderColor(isWorking, isRequestPending)),
      borderRadius: BorderRadius.circular(borderRadius ?? 15),
    );
  }

  Color getBorderColor(bool isWorking, bool isRequestPending) {
    if (isWorking) {
      return Color(0xff2DC75C);
    } else if (isRequestPending) {
      return Colors.red;
    } else {
      return Colors.grey.shade300;
    }
  }

  bool isActiveWorkLog(WorkLogInfo info) {
    return StringHelper.isEmptyString(info.workEndTime);
  }

  String fromToWorkTimeText(WorkLogInfo info) {
    return "(${controller.changeFullDateToSortTime(info.workStartTime)} - ${!StringHelper.isEmptyString(info.workEndTime) ? controller.changeFullDateToSortTime(info.workEndTime) : "Working"})";
  }
}
