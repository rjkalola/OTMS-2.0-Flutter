import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/custom_views/dotted_line_vertical_widget.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';

class CheckLogListView extends StatelessWidget {
  final int parentIndex;

  CheckLogListView({super.key, required this.parentIndex});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.workLogData.value.workLogInfo![parentIndex]
                      .userChecklogs ??
                  [])
              .isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(left: 0),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(), //
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: List.generate(
                  controller.workLogData.value.workLogInfo![parentIndex]
                      .userChecklogs!.length,
                  (position) {
                    var info = controller.workLogData.value
                        .workLogInfo![parentIndex].userChecklogs![position];
                    print("check Log:" + info.checkinDateTime!);
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
                              SizedBox(
                                width: 22,
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // CustomPaint(
                              //     size: Size(1.3, double.infinity),
                              //     painter: DottedLineVerticalWidget(
                              //         color: Colors.green)),
                              SizedBox(
                                width: 10,
                              )
                              // circle(info),
                              // addCircle(id: info.id ?? 0)
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
                                        height: 86,
                                        decoration: itemDecoration(
                                            isRequestPending: false,
                                            isWorking: isActiveWorkLog(info),
                                            boxShadow: [
                                              AppUtils.boxShadow(
                                                  shadowColor_(context), 6)
                                            ]),
                                        child: GestureDetector(
                                          onTap: () {
                                            var arguments = {
                                              AppConstants.intentKey.checkLogId:
                                                  info.id ?? 0,
                                              AppConstants.intentKey
                                                  .projectId: controller
                                                      .workLogData
                                                      .value
                                                      .workLogInfo![parentIndex]
                                                      .projectId ??
                                                  0
                                            };
                                            controller.moveToScreen(
                                                AppRoutes.checkOutScreen,
                                                arguments);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    setProjectNameTextView(
                                                        info.addressName ?? ""),
                                                    setProjectNameTextView(
                                                        !StringHelper
                                                                .isEmptyString(info
                                                                    .typeOfWorkName)
                                                            ? info
                                                                .typeOfWorkName
                                                            : info.tradeName)
                                                  ],
                                                ),
                                                Expanded(
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
                                                        // text: !StringHelper
                                                        //         .isEmptyString(info
                                                        //             .checkoutDateTime)
                                                        //     ? DateUtil
                                                        //         .seconds_To_HH_MM(
                                                        //             info.totalWorkSeconds ??
                                                        //                 0)
                                                        //     : controller
                                                        //         .activeWorkHours
                                                        //         .value,
                                                        text: DateUtil
                                                            .seconds_To_HH_MM(
                                                                info.totalWorkSeconds ??
                                                                    0),
                                                        fontSize: 20,
                                                        // fontColor: isActiveWorkLog(
                                                        //         info)
                                                        //     ? Colors.white
                                                        //     : primaryTextColor_(
                                                        //         context),
                                                        fontColor:
                                                            primaryTextColor_(
                                                                context),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        boxColor:
                                                            Colors.transparent,
                                                        /* boxColor:
                                                          isActiveWorkLog(info)
                                                              ? Colors.green
                                                              : Colors
                                                                  .transparent,*/
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          PrimaryTextView(
                                                            text:
                                                                "(${controller.changeFullDateToSortTime(info.checkinDateTime)}",
                                                            fontSize: 15,
                                                            color:
                                                                primaryTextColor_(
                                                                    context),
                                                          ),
                                                          PrimaryTextView(
                                                            text: " - ",
                                                            fontSize: 15,
                                                            color:
                                                                primaryTextColor_(
                                                                    context),
                                                          ),
                                                          PrimaryTextView(
                                                            text:
                                                                toWorkTimeText(
                                                                    info),
                                                            fontSize: 15,
                                                            color: isActiveWorkLog(
                                                                    info)
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
                                                RightArrowWidget(
                                                  size: 30,
                                                  color: primaryTextColor_(
                                                      context),
                                                ),
                                                SizedBox(
                                                  width: 6,
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
                                          text: 'check_in_'.tr,
                                          color: "#007AFF")
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

  Widget setProjectNameTextView(String? text) =>
      !StringHelper.isEmptyString(text)
          ? Container(
              width: 70,
              margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
              padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
              decoration: BoxDecoration(
                  color: ThemeConfig.isDarkMode
                      ? Color(0xFF339CFF)
                      : Color(0xffACDBFE),
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
            )
          : Container(
              width: 70,
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

  Widget dottedLine({required int id, Color? color}) => Column(
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

  Widget circle(CheckLogInfo info) => Visibility(
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

  bool isActiveWorkLog(CheckLogInfo info) {
    return StringHelper.isEmptyString(info.checkoutDateTime);
  }

  String toWorkTimeText(CheckLogInfo info) {
    return "${!StringHelper.isEmptyString(info.checkoutDateTime) ? controller.changeFullDateToSortTime(info.checkoutDateTime) : "Working"})";
  }
}
