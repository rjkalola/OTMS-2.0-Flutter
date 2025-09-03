import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/notifications/notification_settings/controller/notification_setting_controller.dart';
import 'package:belcka/pages/notifications/notification_settings/model/notification_setting_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class NotificationSettingSubList extends StatelessWidget {
  NotificationSettingSubList({super.key, required this.parentPosition});

  final controller = Get.put(NotificationSettingController());
  final int parentPosition;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          NotificationSettingInfo info = controller
              .notificationSettingList[parentPosition].notifications![position];
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 2, 18, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PrimaryTextView(
                    text: info.name,
                    color: primaryTextColor_(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 9,
                ),
                Row(
                  children: [
                    CustomSwitch(
                        onValueChange: (value) {
                          print("value:" + value.toString());
                          info.isPush = !info.isPush!;
                          controller.notificationSettingList.refresh();
                          controller.isDataUpdated.value = true;
                          controller.checkSelectAll();
                          // controller.changeCompanyTradeStatusApi(
                          //     info.id ?? 0, value);
                        },
                        mValue: info.isPush),
                    CustomSwitch(
                        onValueChange: (value) {
                          print("value:" + value.toString());
                          info.isFeed = !info.isFeed!;
                          controller.notificationSettingList.refresh();
                          controller.isDataUpdated.value = true;
                          controller.checkSelectAll();
                          // controller.changeCompanyTradeStatusApi(
                          //     info.id ?? 0, value);
                        },
                        mValue: info.isFeed)
                  ],
                )
              ],
            ),
          );
        },
        itemCount: controller
            .notificationSettingList[parentPosition].notifications!.length,
        separatorBuilder: (context, position) => Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Divider(
                height: 0,
                color: dividerColor_(context),
                thickness: 1,
              ),
            )));
  }
}
