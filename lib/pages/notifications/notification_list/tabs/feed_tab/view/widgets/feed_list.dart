import 'package:belcka/pages/notifications/notification_list/model/feed_info.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/feed_tab/controller/feed_tab_controller.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/feed_tab/view/widgets/message_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedList extends StatelessWidget {
  FeedList({super.key});

  final controller = Get.put(FeedTabController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 9),
        child: ListView.separated(
            controller: controller.scrollController,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, position) {
              FeedInfo info = controller.feedList[position];
              return Dismissible(
                key: ValueKey(info.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  margin: const EdgeInsets.fromLTRB(9, 4, 9, 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) => controller.deleteFeed(info),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9, 4, 9, 4),
                  child: CardViewDashboardItem(
                    boxColor: !(info.isRead ?? false)
                        ? ThemeConfig.isDarkMode
                            ? AppUtils.getColor("#22242f")
                            : AppUtils.getColor("#edf2fb")
                        // : backgroundColor_(context),
                        : null,
                    child: GestureDetector(
                      onTap: () {
                        controller.notificationClick(info, position);
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            UserAvtarView(
                              imageUrl: info.userThumbImage ?? "",
                              imageSize: 52,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MessageView(
                                    userName: info.userName ?? "",
                                    message: info.message ?? "",
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  PrimaryTextView(
                                    text: info.dateAdded ?? "",
                                    fontSize: 14,
                                    color: secondaryLightTextColor_(context),
                                    fontWeight: FontWeight.w400,
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
                ),
              );
            },
            itemCount: controller.feedList.length,
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
