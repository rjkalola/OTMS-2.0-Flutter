import 'package:belcka/pages/check_in/check_in_day_logs/controller/check_in_day_logs_controller.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../res/theme/theme_config.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/date_utils.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';
import '../../../clock_in/model/check_log_info.dart';

class CheckInDayLogsList extends StatelessWidget {
  CheckInDayLogsList({super.key});

  final controller = Get.put(CheckInDayLogsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.listItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(left: 0),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(
                  controller.listItems.length,
                  (position) {
                    final info = controller.listItems[position];

                    return IntrinsicHeight(
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16, top: 9, bottom: 14, right: 16),
                            height: 86,
                            decoration: itemDecoration(
                              isRequestPending: false,
                              isWorking: isActiveWorkLog(info),
                              boxShadow: [
                                AppUtils.boxShadow(shadowColor_(context), 6)
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                var arguments = {
                                  AppConstants.intentKey.checkLogId:
                                      info.id ?? 0,
                                  AppConstants.intentKey.isPriceWork:
                                      info.isPricework ?? false
                                };
                                controller.moveToScreen(
                                    AppRoutes.checkOutScreen, arguments);
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        setProjectNameTextView(
                                            info.addressName ?? ""),
                                        setProjectNameTextView(
                                          !StringHelper.isEmptyString(
                                                  info.companyTaskName)
                                              ? info.companyTaskName
                                              : info.tradeName,
                                        ),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            borderRadius: 6,
                                            text: (info.isPricework ?? false)
                                                ? (StringHelper.isEmptyString(
                                                        info.checkoutDateTime)
                                                    ? 'working'.tr
                                                    : "£${info.priceWorkTotalAmount ?? ""}")
                                                : DateUtil.seconds_To_HH_MM(
                                                    info.totalWorkSeconds ?? 0),
                                            fontSize: 20,
                                            fontColor:
                                                primaryTextColor_(context),
                                            fontWeight: FontWeight.bold,
                                            boxColor: Colors.transparent,
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              PrimaryTextView(
                                                text:
                                                    "(${changeFullDateToSortTime(info.checkinDateTime)}",
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
                                                text: toWorkTimeText(info),
                                                fontSize: 15,
                                                color: isActiveWorkLog(info)
                                                    ? defaultAccentColor_(
                                                        context)
                                                    : primaryTextColor_(
                                                        context),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    RightArrowWidget(
                                      size: 30,
                                      color: primaryTextColor_(context),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          setItemTypeTextView(
                            text: 'check_in_'.tr,
                            color: "#007AFF",
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // -------------------- HELPER METHODS --------------------

  String getDate(LeaveInfo info) {
    if (info.isAlldayLeave ?? false) {
      return "${info.startDate ?? ""} - ${info.endDate ?? ""}";
    }
    return info.startDate ?? "";
  }

  String getTime(LeaveInfo info) {
    return "${info.startTime ?? ""} to ${info.endTime ?? ""}";
  }

  Decoration? itemDecoration({
    required bool isWorking,
    required bool isRequestPending,
    double? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: backgroundColor_(Get.context!),
      boxShadow: boxShadow,
      border: Border.all(
        width: 0.9,
        color: getBorderColor(isWorking, isRequestPending),
      ),
      borderRadius: BorderRadius.circular(borderRadius ?? 15),
    );
  }

  Color getBorderColor(bool isWorking, bool isRequestPending) {
    if (isWorking) {
      return const Color(0xff2DC75C);
    } else if (isRequestPending) {
      return Colors.red;
    } else {
      return ThemeConfig.isDarkMode
          ? const Color(0xFF1F1F1F)
          : Colors.grey.shade300;
    }
  }

  bool isActiveWorkLog(CheckLogInfo info) {
    return StringHelper.isEmptyString(info.checkoutDateTime);
  }

  String toWorkTimeText(CheckLogInfo info) {
    return "${!StringHelper.isEmptyString(info.checkoutDateTime) ? changeFullDateToSortTime(info.checkoutDateTime) : "Working"})";
  }

  Widget setProjectNameTextView(String? text) {
    return !StringHelper.isEmptyString(text)
        ? Container(
            width: 70,
            margin: const EdgeInsets.fromLTRB(10, 3, 10, 3),
            padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
            decoration: BoxDecoration(
              color: ThemeConfig.isDarkMode
                  ? const Color(0xFF339CFF)
                  : const Color(0xffACDBFE),
              borderRadius: BorderRadius.circular(4),
            ),
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
        : const SizedBox(width: 70);
  }

  Widget setItemTypeTextView({
    required String text,
    required String color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
          decoration: BoxDecoration(
            color: Color(AppUtils.haxColor(color)),
            borderRadius: BorderRadius.circular(45),
          ),
          child: PrimaryTextView(
            text: text,
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  String changeFullDateToSortTime(String? date) {
    return !StringHelper.isEmptyString(date)
        ? DateUtil.changeDateFormat(
            date!,
            DateUtil.DD_MM_YYYY_TIME_24_SLASH2,
            DateUtil.HH_MM_24,
          )
        : "";
  }
}
