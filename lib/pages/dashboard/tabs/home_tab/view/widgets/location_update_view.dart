import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class LocationUpdateView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  LocationUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
      child: Row(children: [
        Container(
            padding: EdgeInsets.all(9),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(AppUtils.haxColor("#ddeafb"))),
            child: SvgPicture.asset(
              Drawable.mapIcon,
            )),
        Expanded(
            child: Padding(
          padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("2/28",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        )),
                    SizedBox(
                      width: 9,
                    ),
                    Text('location_updates'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ))
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("15:05",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        )),
                    SizedBox(
                      width: 9,
                    ),
                    Text('next_updates'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ))
                  ],
                ),
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
