import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:otm_inventory/pages/project/trade_records/controller/trade_records_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/shapes/badge_count_widget.dart';
import 'package:otm_inventory/widgets/text/SubTitleTextView.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';

class TradeUserRecords extends StatelessWidget {
  TradeUserRecords({super.key});

  final controller = Get.put(TradeRecordsController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            CheckLogInfo info = controller.listItems[position];
            return Stack(
              children: [
                CardViewDashboardItem(
                  margin: const EdgeInsets.fromLTRB(12, 9, 12, 10),
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                        /*  var arguments = {
                            AppConstants.intentKey.checkLogId: info.id ?? 0,
                          };
                          controller.moveToScreen(
                              AppRoutes.checkOutScreen, arguments);*/
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
                    visible: (info.totalCheckLogs ?? 0) > 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 0),
                      child: CustomBadgeIcon(
                        count: info.totalCheckLogs ?? 0,
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
          itemCount: controller.listItems.length,
          // separatorBuilder: (context, position) => const Padding(
          //   padding: EdgeInsets.only(left: 100),
          //   child: Divider(
          //     height: 0,
          //     color: dividerColor,
          //     thickness: 0.8,
          //   ),
          // ),
          separatorBuilder: (context, position) => Container()),
    );
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
            text: "${DateUtil.seconds_To_HH_MM(info.totalWorkSeconds ?? 0)} h",
            color: primaryTextColor_(Get.context!),
            fontSize: 17,
          ),
        ],
      );
}
