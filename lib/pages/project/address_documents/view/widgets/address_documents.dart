import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/project/address_documents/controller/address_documents_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/shapes/badge_count_with_child_widget.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressDocuments extends StatelessWidget {
  AddressDocuments({super.key});

  final controller = Get.put(AddressDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            TypeOfWorkResourcesInfo info = controller.listItems[position];
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.typeOfWorkDetails(info);
                  },
                  child: CardViewDashboardItem(
                      elevation: 1,
                      shadowColor: Colors.black45,
                      borderRadius: 16,
                      margin: EdgeInsets.fromLTRB(14, 13, 14, 16),
                      padding: EdgeInsets.fromLTRB(16, 18, 12, 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: TitleTextView(
                              text: info.name ?? "",
                              fontSize: 17,
                            ),
                          ),
                          CustomBadgeIcon(count: info.totalAttachments ?? 0),
                          RightArrowWidget()
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Row(
                    children: [
                      textContainerItem(
                          info.tradeName ?? "", AppUtils.getColor("#FF7F00")),
                      textContainerItem(
                          info.duration ?? "", AppUtils.getColor("#7523D3")),
                      (info.isPricework ?? false)
                          ? textContainerItem(
                              info.rate ?? "", AppUtils.getColor("#FF008C"))
                          : textContainerItem(info.repeatableJob ?? "",
                              AppUtils.getColor("#32A852")),
                      textContainerItem(info.locationName ?? "",
                          AppUtils.getColor("#F44336")),
                    ],
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

  Widget textContainerItem(String text, Color boxColor) {
    return !StringHelper.isEmptyString(text)
        ? Padding(
            padding: const EdgeInsets.only(right: 6, top: 4),
            child: TextViewWithContainer(
              alignment: Alignment.center,
              height: 22,
              text: text ?? "",
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              fontColor: Colors.white,
              fontSize: 12,
              boxColor: boxColor,
              borderRadius: 5,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          )
        : Container();
  }
}
