import 'package:belcka/pages/leaves/leave_list/controller/leave_list_controller.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
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
            return Stack(
              children: [
                CardViewDashboardItem(
                  margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  padding: const EdgeInsets.fromLTRB(12, 22, 12, 12),
                  borderRadius: 15,
                  child: GestureDetector(
                    onTap: () {
                      var arguments = {
                        AppConstants.intentKey.leaveInfo: info,
                        AppConstants.intentKey.userId: controller.userId,
                      };
                      controller.moveToScreen(
                          AppRoutes.createLeaveScreen, arguments);
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
                              imageUrl: info.userThumbImage??"",
                              imageSize: 50,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextView(
                                text: info.userName ?? "",
                                fontSize: 17,
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                TextViewWithContainer(
                  margin: EdgeInsets.only(left: 32),
                  text: info.leaveName ?? "",
                  padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
                  fontColor: Colors.white,
                  fontSize: 14,
                  boxColor: defaultAccentColor_(context),
                  borderRadius: 5,
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
