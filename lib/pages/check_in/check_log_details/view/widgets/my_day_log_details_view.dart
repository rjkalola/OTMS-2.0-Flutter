import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/check_log_details/controller/check_log_details_controller.dart';
import 'package:otm_inventory/pages/check_in/check_log_details/view/widgets/check_log_list_view.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/custom_views/dotted_line_vertical_widget.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';

class MyDayLogDetailsView extends StatelessWidget {
  MyDayLogDetailsView({super.key});

  final controller = Get.put(CheckLogDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          IntrinsicHeight(
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
                    dottedLine(id: controller.workInfo.value.id ?? 0),
                    circle(controller.workInfo.value),
                    addCircle(id: controller.workInfo.value.id ?? 0)
                  ],
                ),
                controller.workInfo.value.id != 0
                    ? Expanded(
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 8, top: 8, bottom: 10, right: 3),
                              height: 86,
                              decoration: itemDecoration(
                                  isRequestPending: controller
                                          .workInfo.value.isRequestPending ??
                                      false,
                                  isWorking: isActiveWorkLog(
                                      controller.workInfo.value),
                                  boxShadow: [
                                    AppUtils.boxShadow(shadowColor_(context), 6)
                                  ]),
                              child: InkWell(
                                onTap: () {
                                  // controller.onClickWorkLogItem(
                                  //     controller.workInfo.value);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        setProjectNameTextView(controller
                                                .workInfo.value.shiftName ??
                                            ""),
                                        Visibility(
                                            visible:
                                                !StringHelper.isEmptyString(
                                                    controller.workInfo.value
                                                        .projectName),
                                            child: SizedBox(
                                              height: 6,
                                            )),
                                        setProjectNameTextView(controller
                                                .workInfo.value.projectName ??
                                            "")
                                      ],
                                    ),
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
                                            text: !StringHelper.isEmptyString(
                                                    controller.workInfo.value
                                                        .workEndTime)
                                                ? DateUtil.seconds_To_HH_MM(
                                                    controller.workInfo.value
                                                            .payableWorkSeconds ??
                                                        0)
                                                : controller
                                                    .activeWorkHours.value,
                                            fontSize: 20,
                                            fontColor: isActiveWorkLog(
                                                    controller.workInfo.value)
                                                ? Colors.white
                                                : primaryTextColor_(context),
                                            fontWeight: FontWeight.bold,
                                            boxColor: isActiveWorkLog(
                                                    controller.workInfo.value)
                                                ? Colors.green
                                                : Colors.transparent,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              PrimaryTextView(
                                                text:
                                                    "(${controller.changeFullDateToSortTime(controller.workInfo.value.workStartTime)}",
                                                fontSize: 15,
                                                color:
                                                    primaryTextColor_(context),
                                              ),
                                              PrimaryTextView(
                                                text: " - ",
                                                fontSize: 15,
                                                color:
                                                    primaryTextColor_(context),
                                              ),
                                              PrimaryTextView(
                                                text: toWorkTimeText(
                                                    controller.workInfo.value),
                                                fontSize: 15,
                                                color: isActiveWorkLog(
                                                        controller
                                                            .workInfo.value)
                                                    ? defaultAccentColor_(
                                                        context)
                                                    : primaryTextColor_(
                                                        context),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 45,
                                      height: double.infinity,
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      decoration: itemDecoration(
                                          isRequestPending: controller.workInfo
                                                  .value.isRequestPending ??
                                              false,
                                          isWorking: isActiveWorkLog(
                                              controller.workInfo.value),
                                          borderRadius: 14),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
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
          ),
          CheckLogListView()
        ],
      ),
    );
  }

  Widget setProjectNameTextView(String? text) => Visibility(
      visible: !StringHelper.isEmptyString(text),
      child: Container(
        width: 70,
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(
            color:
                ThemeConfig.isDarkMode ? Color(0xFF339CFF) : Color(0xffACDBFE),
            borderRadius: BorderRadius.circular(4)),
        child: PrimaryTextView(
          text: text ?? "",
          fontSize: 14,
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
          onTap: () {},
          child: ImageUtils.setSvgAssetsImage(
              path: Drawable.addCreateNewPlusIcon,
              width: 22,
              height: 22,
              color: primaryTextColor_(Get.context!)),
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
      color: backgroundColor_(Get.context!),
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
      return ThemeConfig.isDarkMode ? Color(0xFF1F1F1F) : Colors.grey.shade300;
    }
  }

  bool isActiveWorkLog(WorkLogInfo info) {
    return StringHelper.isEmptyString(info.workEndTime);
  }

  String toWorkTimeText(WorkLogInfo info) {
    return "${!StringHelper.isEmptyString(info.workEndTime) ? controller.changeFullDateToSortTime(info.workEndTime) : "Working"})";
  }
}
