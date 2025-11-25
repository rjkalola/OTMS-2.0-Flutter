import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
        borderRadius: 14,
        margin: EdgeInsets.fromLTRB(14, 4, 14, 12),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextView(
                textAlign: TextAlign.start,
                text: "${'current_log_summery'.tr}:",
                color: primaryTextColor_(context),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: 10,
              ),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, position) {
                    // UserInfo info = controller.usersList[position];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: PrimaryTextView(
                              textAlign: TextAlign.start,
                              text: "(09:15 - 11:00)",
                              color: primaryTextColor_(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          PrimaryTextView(
                            textAlign: TextAlign.start,
                            text: "01:25",
                            color: primaryTextColor_(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: 3,
                  // separatorBuilder: (context, position) => const Padding(
                  //   padding: EdgeInsets.only(left: 100),
                  //   child: Divider(
                  //     height: 0,
                  //     color: dividerColor,
                  //     thickness: 0.8,
                  //   ),
                  // ),
                  separatorBuilder: (context, position) => Container()),
              SizedBox(height: 6,),
              Divider(),
              SizedBox(height: 6,),
              Row(
                children: [
                  Expanded(
                    child: PrimaryTextView(
                      textAlign: TextAlign.start,
                      text: "${'penalty'.tr}:",
                      color: primaryTextColor_(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PrimaryTextView(
                    textAlign: TextAlign.start,
                    text: "02:00",
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
              SizedBox(height: 6,),
              Divider(),
              SizedBox(height: 6,),
              Row(
                children: [
                  Expanded(
                    child: PrimaryTextView(
                      textAlign: TextAlign.start,
                      text: "${'check_in_'.tr}:",
                      color: primaryTextColor_(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PrimaryTextView(
                    textAlign: TextAlign.start,
                    text: "3(200\$)",
                    color: primaryTextColor_(context),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
              SizedBox(height: 6,),
            ],
          ),
        ));
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
}
