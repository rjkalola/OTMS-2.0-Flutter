import 'package:belcka/pages/check_in/penalty/penalty_list/controller/penalty_list_controller.dart';
import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';
import 'package:belcka/pages/leaves/leave_list/controller/leave_list_controller.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            // PenaltyInfo info = controller.listItems[position];
            // int status = info.requestStatus ?? 0;
            return Stack(
              children: [
                CardViewDashboardItem(
                  margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  borderRadius: 15,
                  child: GestureDetector(
                    onTap: () {
                      /*if (status == 0 ||
                          status == AppConstants.status.approved) {
                        var arguments = {
                          AppConstants.intentKey.leaveInfo: info,
                          AppConstants.intentKey.userId: controller.userId,
                        };
                        controller.moveToScreen(
                            AppRoutes.createLeaveScreen, arguments);
                      } else {
                        var arguments = {
                          AppConstants.intentKey.leaveId: info.id ?? 0,
                        };
                        controller.moveToScreen(
                            AppRoutes.leaveDetailsScreen, arguments);
                      }*/
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
                                      text: "00:45",
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
                                      text: "00:45",
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
                                      text: "00:45",
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
                            thickness: 1 ,
                          ),
                          TitleTextView(
                            text: "Automatic stop work: -00:50",
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Visibility(
                //   visible: !StringHelper.isEmptyString(
                //       AppUtils.getStatusText(info.requestStatus ?? 0)),
                //   child: Align(
                //     alignment: Alignment.topRight,
                //     child: TextViewWithContainer(
                //       margin: EdgeInsets.only(right: 32, top: 2),
                //       text: AppUtils.getStatusText(info.requestStatus ?? 0),
                //       padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                //       fontColor: Colors.white,
                //       fontSize: 11,
                //       boxColor:
                //           AppUtils.getStatusColor(info.requestStatus ?? 0),
                //       borderRadius: 5,
                //     ),
                //   ),
                // )
              ],
            );
          },
          itemCount: 5,
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

  String getDate(LeaveInfo info) {
    String date = "";
    if (info.isAlldayLeave ?? false) {
      date = "${info.startDate ?? ""} - ${info.endDate ?? ""}";
    } else {
      date = info.startDate ?? "";
    }
    return date;
  }

  String getTime(LeaveInfo info) {
    return "${info.startTime ?? ""} to ${info.endTime ?? ""}";
  }
}
