import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class CurrentLogSummery extends StatelessWidget {
  CurrentLogSummery({super.key});

  final controller = Get.put(StopShiftController());
  List<Widget> listItems = [];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      setWidgets(context);

      return Visibility(
        visible: controller.isShowTotalPayable.value,
        child: CardViewDashboardItem(
          borderRadius: 14,
          margin: const EdgeInsets.fromLTRB(14, 4, 14, 12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
            child: Column(
              children: List.generate(
                listItems.length,
                (index) => Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: listItems[index],
                    ),
                    if (index != listItems.length - 1)
                      Padding(
                        padding: EdgeInsets.only(top: 6, bottom: 6),
                        child: Divider(
                          thickness: 1,
                          height: 0,
                          color: dividerColor_(context),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Color getColor(BuildContext context) {
    Color color = primaryTextColor_(context);
    if (controller.isEdited.value) {
      color = Colors.red;
    } else {
      if (!StringHelper.isEmptyString(
          controller.workLogInfo.value.workEndTime)) {
        color = AppUtils.getStatusColor(
            controller.workLogInfo.value.requestStatus ?? 0);
      } else {
        color = defaultAccentColor_(context);
      }
    }
    return color;
  }

  void setWidgets(BuildContext context) {
    listItems.clear();
    if ((controller.workLogInfo.value.allWorklogsSeconds ?? 0) > 0) {
      listItems.add(Padding(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Row(
          children: [
            Expanded(
              child: PrimaryTextView(
                textAlign: TextAlign.start,
                text: "${'worklog_summary'.tr}:",
                color: primaryTextColor_(context),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            PrimaryTextView(
              textAlign: TextAlign.start,
              text: DateUtil.seconds_To_HH_MM(
                  controller.workLogInfo.value.allWorklogsSeconds ?? 0),
              color: primaryTextColor_(context),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 75,
              child: PrimaryTextView(
                textAlign: TextAlign.start,
                text:
                    "${controller.currency.value}${controller.workLogInfo.value.allWorklogsAmount ?? "0"}",
                color: primaryTextColor_(context),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 21,
            )
          ],
        ),
      ));
    }

    if ((controller.workLogInfo.value.allPenaltySeconds ?? 0) > 0) {
      listItems.add(Padding(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Row(
          children: [
            Expanded(
              child: PrimaryTextView(
                textAlign: TextAlign.start,
                text: "${'penalty'.tr}:",
                color: primaryTextColor_(context),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            PrimaryTextView(
              textAlign: TextAlign.start,
              text: DateUtil.seconds_To_HH_MM(
                  controller.workLogInfo.value.allPenaltySeconds ?? 0),
              color: primaryTextColor_(context),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 75,
              child: PrimaryTextView(
                textAlign: TextAlign.start,
                text:
                    "${controller.currency.value}${controller.workLogInfo.value.totalPenaltyAmount ?? "0"}",
                color: Colors.red,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 21,
            )
          ],
        ),
      ));
    }

    if ((controller.workLogInfo.value.allChecklogCount ?? 0) > 0) {
      listItems.add(Padding(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: GestureDetector(
          onTap: () {
            controller.moveToScreen(AppRoutes.checkInDayLogsScreen, null);
          },
          child: Row(
            children: [
              Expanded(
                child: PrimaryTextView(
                  textAlign: TextAlign.start,
                  text: "${'check_in_'.tr}:",
                  color: primaryTextColor_(context),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 75,
                child: PrimaryTextView(
                  textAlign: TextAlign.start,
                  text:
                      "${controller.currency.value}${controller.workLogInfo.value.allChecklogAmount ?? "0"}",
                  color: primaryTextColor_(context),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomBadgeIcon(
                count: controller.workLogInfo.value.allChecklogCount ?? 0,
                color: defaultAccentColor_(context),
              )
            ],
          ),
        ),
      ));
    }

    if ((controller.workLogInfo.value.allExpenseCount ?? 0) > 0) {
      listItems.add(Padding(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Row(
          children: [
            Expanded(
              child: PrimaryTextView(
                textAlign: TextAlign.start,
                text: "${'expense'.tr}:",
                color: primaryTextColor_(context),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 75,
              child: PrimaryTextView(
                textAlign: TextAlign.start,
                text:
                    "${controller.currency.value}${controller.workLogInfo.value.allExpenseAmount ?? "0"}",
                color: primaryTextColor_(context),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            CustomBadgeIcon(
              count: controller.workLogInfo.value.allExpenseCount ?? 0,
              color: defaultAccentColor_(context),
            )
          ],
        ),
      ));
    }
  }
}
