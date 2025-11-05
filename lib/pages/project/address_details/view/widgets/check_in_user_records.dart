import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/project/address_details/controller/address_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';

class CheckInUserRecords extends StatelessWidget {
  CheckInUserRecords({super.key, required this.parentPosition});

  final controller = Get.put(AddressDetailsController());
  final int parentPosition;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          CheckLogInfo info =
          controller.listCheckInRecords[parentPosition].data![position];
          return Stack(
            children: [
              CardViewDashboardItem(
                margin: const EdgeInsets.fromLTRB(12, 9, 12, 10),
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        var arguments = {
                          AppConstants.intentKey.checkLogId: info.id ?? 0,
                        };
                        controller.moveToScreen(
                            AppRoutes.checkOutScreen, arguments);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            UserAvtarView(imageUrl: info.userThumbImage ?? ""),
                            SizedBox(
                              width: 9,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleTextView(
                                    text: info.userName,
                                  ),
                                  shiftName(info),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // totalWorkHour(info),
                            totalWorkHour(info),
                            SizedBox(
                              width: 4,
                            ),
                            RightArrowWidget(
                              color: primaryTextColor_(context),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 6),
                    child: CustomBadgeIcon(
                      count: 0,
                      color: defaultAccentColor_(context),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !StringHelper.isEmptyString(info.tradeName),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: TextViewWithContainer(
                        height: 18,
                        padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                        fontSize: 12,
                        text: info.tradeName ?? "",
                        fontColor: Colors.white,
                        boxColor: AppUtils.getColor("#FF7F00"),
                      ),
                    )),
              )
            ],
          );
        },
        itemCount: controller.listCheckInRecords[parentPosition].data!.length,
        // separatorBuilder: (context, position) => const Padding(
        //   padding: EdgeInsets.only(left: 100),
        //   child: Divider(
        //     height: 0,
        //     color: dividerColor,
        //     thickness: 0.8,
        //   ),
        // ),
        separatorBuilder: (context, position) => Container()),);
  }

  Widget shiftName(CheckLogInfo info) {
    String name = "";
    if (!StringHelper.isEmptyString(info.companyTaskName)) {
      name = info.companyTaskName ?? "";
    }
    return !StringHelper.isEmptyString(name)
        ? IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: TextViewWithContainer(
                text: name ?? "",
                padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
                fontColor: ThemeConfig.isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                boxColor: ThemeConfig.isDarkMode
                    ? Color(0xFF4BA0F3)
                    : Color(0xffACDBFE),
                borderRadius: 5,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          )
        : Container();
  }

  Widget totalWorkHour(CheckLogInfo info) => Column(
        children: [
          TitleTextView(
            text: DateUtil.seconds_To_HH_MM(info.totalWorkSeconds ?? 0),
            color: primaryTextColor_(Get.context!),
            fontSize: 17,
          ),
          SubtitleTextView(
            text:
                "(${info.formattedCheckInTime} - ${info.formattedCheckOutTime})",
            fontSize: 13,
          )
        ],
      );
}
