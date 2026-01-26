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
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, position) {
              FeedInfo info = controller.feedList[position];
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
                      // var arguments = {
                      //   AppConstants.intentKey.userId: info.id ?? 0,
                      //   AppConstants.intentKey.userName: info.name ?? "",
                      //   AppConstants.intentKey.userList: controller.usersList,
                      // };
                      // Get.toNamed(AppRoutes.userPermissionScreen,
                      //     arguments: arguments);

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
                                // PrimaryTextView(
                                //   text: info.message ?? "",
                                //   fontSize: 17,
                                //   color: primaryTextColor_(context),
                                //   fontWeight: FontWeight.w500,
                                // ),
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
