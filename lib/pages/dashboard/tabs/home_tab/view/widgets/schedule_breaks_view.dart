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

class ScheduleBreaksView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  ScheduleBreaksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      alignment: Alignment.center,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: List.generate(
          2,
          (position) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
                child: Row(children: [
                  Container(
                      padding: EdgeInsets.all(9),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(AppUtils.haxColor("#fee8d0"))),
                      child: SvgPicture.asset(
                        Drawable.breakInIcon,
                      )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: Center(
                      child: Column(
                        children: const [
                          Text("Schedule break 08:00 - 22:00",
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
                              ))
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
              ),
              Divider(
                thickness: 3,
                color: dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
