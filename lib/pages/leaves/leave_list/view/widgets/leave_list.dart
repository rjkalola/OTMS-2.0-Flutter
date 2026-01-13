import 'package:belcka/pages/leaves/leave_list/controller/leave_list_controller.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/pages/leaves/leave_utils.dart';
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

class LeaveList extends StatelessWidget {
  LeaveList({super.key});

  final controller = Get.put(LeaveListController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            LeaveInfo info = controller.listItems[position];
            int status = info.requestStatus ?? 0;
            return Stack(
              children: [
                CardViewDashboardItem(
                  margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  padding: const EdgeInsets.fromLTRB(12, 22, 12, 12),
                  borderRadius: 15,
                  child: GestureDetector(
                    onTap: () {
                      if (status == 0 ||
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
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              AppUtils.onClickUserAvatar(info.userId ?? 0);
                            },
                            child: UserAvtarView(
                              imageUrl: info.userThumbImage ?? "",
                              imageSize: 50,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextView(
                                text: info.userName ?? "",
                                fontSize: 17,
                                softWrap: true,
                              ),
                              SubtitleTextView(
                                text: "${'date'.tr}: ${getDate(info)}",
                                fontSize: 16,
                              ),
                              Visibility(
                                visible: !(info.isAlldayLeave ?? false),
                                child: SubtitleTextView(
                                  text: "${'time'.tr}: ${getTime(info)}",
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    TextViewWithContainer(
                      margin: EdgeInsets.only(left: 32, top: 1),
                      text: info.leaveName ?? "",
                      maxLength: 14,
                      overflow: TextOverflow.ellipsis,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      fontColor: Colors.white,
                      fontSize: 13,
                      boxColor: defaultAccentColor_(context),
                      borderRadius: 5,
                    ),
                    TextViewWithContainer(
                      margin: EdgeInsets.only(left: 8, top: 1),
                      text: StringHelper.capitalizeFirstLetter(
                          info.leaveType ?? ""),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      fontColor: Colors.white,
                      fontSize: 13,
                      boxColor:
                          LeaveUtils.getLeaveTypeColor(info.leaveType ?? ""),
                      borderRadius: 5,
                    )
                  ],
                ),
                Visibility(
                  visible: !StringHelper.isEmptyString(
                      AppUtils.getStatusText(info.requestStatus ?? 0)),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextViewWithContainer(
                      margin: EdgeInsets.only(right: 32, top: 2),
                      text: AppUtils.getStatusText(info.requestStatus ?? 0),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      fontColor: Colors.white,
                      fontSize: 11,
                      boxColor:
                          AppUtils.getStatusColor(info.requestStatus ?? 0),
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
