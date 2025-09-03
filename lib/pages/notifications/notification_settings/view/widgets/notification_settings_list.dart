import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/notifications/notification_settings/controller/notification_setting_controller.dart';
import 'package:belcka/pages/notifications/notification_settings/view/widgets/notification_setting_sub_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class NotificationSettingsList extends StatelessWidget {
  NotificationSettingsList({super.key});

  final controller = Get.put(NotificationSettingController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.notificationSettingList[position].isExpanded =
                              !(controller
                                      .notificationSettingList[position].isExpanded ??
                                  false);
                          controller.notificationSettingList.refresh();
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PrimaryTextView(
                                text: controller
                                        .notificationSettingList[position].name ??
                                    "",
                                color: primaryTextColor_(context),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                              !(controller.notificationSettingList[position]
                                          .isExpanded ??
                                      false)
                                  ? Icon(
                                      Icons.keyboard_arrow_up_outlined,
                                      size: 26,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 26,
                                    )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 0,
                        color: dividerColor_(context),
                        thickness: 2,
                      ),
                      Visibility(
                          visible: !(controller
                                  .notificationSettingList[position].isExpanded ??
                              false),
                          child: NotificationSettingSubList(parentPosition: position)),
                    ],
                  ),
                );
              },
              itemCount: controller.notificationSettingList.length,
              // separatorBuilder: (context, position) => const Padding(
              //   padding: EdgeInsets.only(left: 100),
              //   child: Divider(
              //     height: 0,
              //     color: dividerColor,
              //     thickness: 0.8,
              //   ),
              // ),
              separatorBuilder: (context, position) => Container()),
        ));
  }
}
