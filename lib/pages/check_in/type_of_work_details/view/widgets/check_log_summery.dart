import 'package:belcka/pages/check_in/check_in/model/check_log_summery_info.dart';
import 'package:belcka/pages/check_in/type_of_work_details/controller/type_of_work_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckLogSummery extends StatelessWidget {
  CheckLogSummery({super.key});

  final controller = Get.put(TypeOfWorkDetailsController());

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyList(controller.info.value.checkLogSummary)
        ? CardViewDashboardItem(
            margin: EdgeInsets.fromLTRB(14, 14, 14, 14),
            borderRadius: 12,
            child: Container(
              padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TitleTextView(
                        text: 'checklog_summery'.tr,
                        fontWeight: FontWeight.w500,
                      ),
                      Spacer(),
                      TitleTextView(
                        text: DateUtil.seconds_To_HH_MM(
                            controller.info.value.totalPayableSeconds ?? 0),
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Divider(
                    color: dividerColor_(context),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, position) {
                        CheckLogSummeryInfo info =
                            controller.info.value.checkLogSummary![position];
                        return Row(
                          children: [
                            PrimaryTextView(
                              text:
                                  "(${info.checkinDate ?? ""})  ${(info.startTime ?? "")} - ${(info.endTime ?? "")}",
                            ),
                            Spacer(),
                            PrimaryTextView(
                              text: DateUtil.seconds_To_HH_MM(
                                  info.payableSeconds ?? 0),
                              fontSize: 15,
                            ),
                          ],
                        );
                      },
                      itemCount: controller.info.value.checkLogSummary!.length,
                      separatorBuilder: (context, position) => SizedBox(
                            height: 4,
                          ))
                ],
              ),
            ))
        : Container();
  }
}
