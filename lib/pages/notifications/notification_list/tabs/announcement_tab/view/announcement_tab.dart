import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/controller/announcement_tab_controller.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/view/widgets/announcement_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';


class AnnouncementTab extends StatefulWidget {
  AnnouncementTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return AnnouncementTabState();
  }
}

class AnnouncementTabState extends State<AnnouncementTab> {
  final controller = Get.put(AnnouncementTabController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Scaffold(
      backgroundColor: dashBoardBgColor_(context),
      body: AnnouncementList(),
    );
  }

}
