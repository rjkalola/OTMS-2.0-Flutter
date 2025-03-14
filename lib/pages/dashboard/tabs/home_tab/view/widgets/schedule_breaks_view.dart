import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';

class ScheduleBreaksView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  ScheduleBreaksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !StringHelper.isEmptyList(
              controller.dashboardResponse.value.shiftBreaks)
          ? Container(
              margin: EdgeInsets.only(top: 4),
              alignment: Alignment.center,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: List.generate(
                  controller.dashboardResponse.value.shiftBreaks!.length,
                  (position) => isVisibleView(controller
                          .dashboardResponse.value.shiftBreaks![position])
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 12, 14, 12),
                              child: Row(children: [
                                Container(
                                    padding: EdgeInsets.all(9),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(
                                            AppUtils.haxColor("#fee8d0"))),
                                    child: SvgPicture.asset(
                                      Drawable.breakInIcon,
                                    )),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                            getBreakTitle(controller
                                                .dashboardResponse
                                                .value
                                                .shiftBreaks![position]),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: secondaryLightTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            )),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text("00:30:00",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: primaryTextColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24,
                                            ))
                                      ],
                                    ),
                                  ),
                                )),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 24,
                                  color: defaultAccentColor,
                                ),
                              ]),
                            ),
                            Divider(
                              thickness: 3,
                              color: dividerColor,
                            ),
                          ],
                        )
                      : Container(),
                ),
              ),
            )
          : Container(),
    );
  }

  bool isVisibleView(ShiftBreaks info) {
    bool isVisible = false;
    if ((!StringHelper.isEmptyString(info.start) &&
            !StringHelper.isEmptyString(info.end)) &&
        (info.start != "00:00:00" && info.end != "00:00:00")) {
      isVisible = true;
    }
    return isVisible;
  }

  String getBreakTitle(ShiftBreaks info) {
    String title = "";
    if (!StringHelper.isEmptyString(info.start) &&
        !StringHelper.isEmptyString(info.end)) {
      String start = DateUtil.changeDateFormat(
          info.start ?? "", DateUtil.HH_MM_SS_24_2, DateUtil.HH_MM_24);
      String end = DateUtil.changeDateFormat(
          info.end ?? "", DateUtil.HH_MM_SS_24_2, DateUtil.HH_MM_24);
      title = "${'scheduled_break'.tr} $start - $end";
    }
    return title;
  }

  String getBreakTime(ShiftBreaks info) {
    String time = "";
//     try {
//       String checkInDate =
//           controller.dashboardResponse.value.checkinDateTime ?? "";
//       if (!StringHelper.isEmptyString(checkInDate)) {
// //                binding.txtBreakStatus.setVisibility(View.VISIBLE);
//         String checkInDateTime = DateUtil.changeDateFormat(checkInDate,
//             DateUtil.YYYY_MM_DD_TIME_24_DASH2, DateUtil.YYYY_MM_DD_DASH);
//
//         DateTime? breakStartTime = DateUtil.stringToDate(
//             "$checkInDateTime ${info.start ?? ""}",
//             DateUtil.YYYY_MM_DD_TIME_24_DASH2);
//         DateTime? breakEndTime = DateUtil.stringToDate(
//             "$checkInDateTime ${info.end ?? ""}",
//             DateUtil.YYYY_MM_DD_TIME_24_DASH2);
//         DateTime currentTime = DateTime.now();
//
//         if (DateUtils.isSameDay(
//             DateUtil.stringToDate(
//                 "$checkInDateTime ${info.end ?? ""}", DateUtil.YYYY_MM_DD_DASH),
//             currentTime)) {
//           if ((currentTime.isAfter(breakStartTime!) ||
//                   currentTime == breakStartTime) &&
//               (currentTime.isBefore(breakEndTime!) ||
//                   currentTime == breakEndTime)) {
//             int totalBreakTime =
//                 breakEndTime.millisecond - currentTime.millisecond;
//             binding.txtTotalTime.setTextColor(
//                 mContext.getResources().getColor(R.color.colorPrimaryText));
//             binding.txtTotalTime
//                 .setText(AppUtils.getCheckInTime(mContext, totalBreakTime));
//
//           } else if (currentTime.getTime() < breakStartTime.getTime()) {
//             long totalBreakTime =
//                 breakEndTime.getTime() - breakStartTime.getTime();
//             binding.txtTotalTime.setTextColor(
//                 mContext.getResources().getColor(R.color.colorPrimaryText));
//             binding.txtTotalTime
//                 .setText(AppUtils.getCheckInTime(mContext, totalBreakTime));
//
//             binding.txtBreakStatus.setTextColor(
//                 mContext.getResources().getColor(R.color.colorDefaultAccent));
//             binding.txtBreakStatus
//                 .setText(mContext.getString(R.string.upcoming));
//           } else if (currentTime.getTime() > breakEndTime.getTime()) {
//             long totalBreakTime =
//                 breakEndTime.getTime() - breakStartTime.getTime();
//             binding.txtTotalTime.setTextColor(
//                 mContext.getResources().getColor(R.color.colorPrimaryText));
//             binding.txtTotalTime
//                 .setText(AppUtils.getCheckInTime(mContext, totalBreakTime));
//
//             binding.txtBreakStatus.setTextColor(
//                 mContext.getResources().getColor(R.color.colorOrange));
//             binding.txtBreakStatus
//                 .setText(mContext.getString(R.string.finished));
//           } else {
//             binding.txtTotalTime.setText("");
//           }
//         } else {
//           long totalBreakTime =
//               breakEndTime.getTime() - breakStartTime.getTime();
//           binding.txtTotalTime.setTextColor(
//               mContext.getResources().getColor(R.color.colorPrimaryText));
//           binding.txtTotalTime
//               .setText(AppUtils.getCheckInTime(mContext, totalBreakTime));
//
//           binding.txtBreakStatus.setTextColor(
//               mContext.getResources().getColor(R.color.colorOrange));
//           binding.txtBreakStatus.setText(mContext.getString(R.string.finished));
//         }
//       } else {
//         String checkInDateTime = YYYY_MM_DD_DASH.format(new Date());
//
//         binding.txtBreakStatus.setVisibility(View.GONE);
//
//         Date breakStartTime =
//             checkInDateFormat.parse(checkInDateTime + " " + info.getStart());
//         Date breakEndTime =
//             checkInDateFormat.parse(checkInDateTime + " " + info.getEnd());
//
//         long totalBreakTime = breakEndTime.getTime() - breakStartTime.getTime();
//         binding.txtTotalTime.setTextColor(
//             mContext.getResources().getColor(R.color.colorPrimaryText));
//         binding.txtTotalTime
//             .setText(AppUtils.getCheckInTime(mContext, totalBreakTime));
//       }
//     } catch (Exceptione) {
//       binding.txtTotalTime.setText("");
//       binding.txtBreakStatus.setVisibility(View.GONE);
//     }
    return time;
  }
}
