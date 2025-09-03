import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/feed_tab/controller/feed_tab_controller.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/feed_tab/view/widgets/feed_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';


class FeedTab extends StatefulWidget {
  FeedTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return FeedTabState();
  }
}

class FeedTabState extends State<FeedTab> {
  final controller = Get.put(FeedTabController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Scaffold(
      backgroundColor: dashBoardBgColor_(context),
      body: FeedList(),
    );
  }

}
