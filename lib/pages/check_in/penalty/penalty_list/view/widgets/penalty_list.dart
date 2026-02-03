import 'package:belcka/pages/check_in/penalty/penalty_list/controller/penalty_list_controller.dart';
import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../routes/app_routes.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/app_utils.dart';
import '../../../../../../utils/date_utils.dart';
import '../../../../../../utils/string_helper.dart';
import '../../../../../../widgets/text/TextViewWithContainer.dart';

class PenaltyList extends StatelessWidget {
  PenaltyList({super.key});

  final controller = Get.put(PenaltyListController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            PenaltyInfo info = controller.listItems[position];
            int status = info.status ?? 0;
            return Stack(
              children: [
                CardViewDashboardItem(
                  margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  borderRadius: 15,
                  child: GestureDetector(
                    onTap: () {
                      var arguments = {
                        AppConstants.intentKey.penaltyId: info.penaltyId ?? 0,
                      };
                      controller.moveToScreen(
                          AppRoutes.penaltyDetailsScreen, arguments);
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleTextView(
                                      text: 'start_time'.tr,
                                      fontSize: 17,
                                    ),
                                    TitleTextView(
                                      text: info.startTime ?? "",
                                      fontSize: 17,
                                    )
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleTextView(
                                      text: 'end_time'.tr,
                                      fontSize: 17,
                                    ),
                                    TitleTextView(
                                      text: info.endTime ?? "",
                                      fontSize: 17,
                                    )
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TitleTextView(
                                      text: 'total'.tr,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    TitleTextView(
                                      text: DateUtil.seconds_To_HH_MM(
                                          info.payableSeconds ?? 0),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: dividerColor_(context),
                            thickness: 1,
                          ),
                          TitleTextView(
                            text:
                                "${info.penaltyType}: -${DateUtil.seconds_To_HH_MM(info.penaltySeconds ?? 0)}",
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !StringHelper.isEmptyString(
                      AppUtils.getStatusText(status)),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextViewWithContainer(
                      margin: EdgeInsets.only(right: 34, top: 2),
                      text: AppUtils.getStatusText(status),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      fontColor: Colors.white,
                      fontSize: 11,
                      boxColor: AppUtils.getStatusColor(status),
                      borderRadius: 5,
                    ),
                  ),
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
          separatorBuilder: (context, position) => SizedBox(
                height: 12,
              )),
    );
  }
}
