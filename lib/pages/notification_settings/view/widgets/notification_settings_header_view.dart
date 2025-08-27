import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class NotificationSettingsHeaderView extends StatelessWidget {
  const NotificationSettingsHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: dashBoardBgColor_(context),
      margin: EdgeInsets.only(top: 9),
      padding: EdgeInsets.fromLTRB(0, 6, 28, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TitleTextView(
            text: 'push'.tr,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            width: 22,
          ),
          TitleTextView(
            text: 'feed'.tr,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    );
  }
}
