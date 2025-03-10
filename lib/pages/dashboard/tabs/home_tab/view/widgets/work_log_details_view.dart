import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/image_utils.dart';

class WorkLogDetailsView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  WorkLogDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(9),
          width: 40,
          height: 40,
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
          child: Center(
            child: Column(
              children: [
                Text("Schedule work 08:00 - 22:00",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryLightTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    )),
                SizedBox(
                  height: 3,
                ),
                Text("00:30:00",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    )),
                SizedBox(
                  height: 3,
                ),
                Text("Work Started: 06 Dec, 12:38",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryLightTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    )),
              ],
            ),
          ),
        )),
        Icon(
          Icons.keyboard_arrow_right,
          size: 24,
          color: defaultAccentColor,
        ),
      ]),
    );
  }
}
