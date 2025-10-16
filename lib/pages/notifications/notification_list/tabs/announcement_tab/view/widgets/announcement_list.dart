import 'package:belcka/pages/notifications/create_announcement/model/announcement_info.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/view/widgets/attachment_list.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/controller/announcement_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

import '../../../../../../../utils/app_constants.dart';

class AnnouncementList extends StatelessWidget {
  AnnouncementList({super.key});

  final controller = Get.put(AnnouncementTabController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 9),
        child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, position) {
              AnnouncementInfo info = controller.announcementList[position];
              return Padding(
                padding: const EdgeInsets.fromLTRB(9, 4, 9, 4),
                child: CardViewDashboardItem(
                  boxColor: !(info.isRead ?? false)
                      ? ThemeConfig.isDarkMode
                          ? AppUtils.getColor("#22242f")
                          : AppUtils.getColor("#edf2fb")
                      : backgroundColor_(context),
                  child: GestureDetector(
                    onTap: () {
                      var arguments = {
                        AppConstants.intentKey.announcementId: info.id ?? 0,
                        AppConstants.intentKey.announcementId: info.id ?? 0,
                      };
                      controller.moveToScreen(
                          AppRoutes.announcementDetailsScreen, arguments);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: UserAvtarView(
                              imageUrl: info.senderThumbImage ?? "",
                              imageSize: 52,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: PrimaryTextView(
                                    text:
                                        "Announcement from ${info.senderName ?? ""}: ${info.name ?? ""}",
                                    fontSize: 17,
                                    color: primaryTextColor_(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                AttachmentList(
                                  onGridItemClick: controller.onGridItemClick,
                                  filesList: info.documents!.obs,
                                  parentIndex: position,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 12, top: 2),
                                  child: PrimaryTextView(
                                    text: info.date ?? "",
                                    fontSize: 14,
                                    color: secondaryLightTextColor_(context),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: controller.announcementList.length,
            // separatorBuilder: (context, position) => const Padding(
            //   padding: EdgeInsets.only(left: 100),
            //   child: Divider(
            //     height: 0,
            //     color: dividerColor,
            //     thickness: 0.8,
            //   ),
            // ),
            separatorBuilder: (context, position) => Container()),
      ),
    );
  }
}
