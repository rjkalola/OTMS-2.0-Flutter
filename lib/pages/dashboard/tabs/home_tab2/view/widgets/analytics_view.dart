import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class AnalyticsView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppUtils.isAdmin()
        ? Padding(
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
                    Drawable.chartPieBarIcon,
                  )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Center(
                  child: Text('analytics'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryTextColor_(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      )),
                ),
              )),
              Icon(
                Icons.keyboard_arrow_right,
                size: 24,
                color: defaultAccentColor_(context),
              ),
            ]),
          )
        : Container();
  }
}
