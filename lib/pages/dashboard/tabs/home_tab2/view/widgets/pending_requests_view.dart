import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class PendingRequestsView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  PendingRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.pendingRequestCount.value > 0
          ? Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
              child: Row(children: [
                Container(
                    padding: EdgeInsets.all(9),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(AppUtils.haxColor("#e4d3f4"))),
                    child: SvgPicture.asset(
                      Drawable.requestCountIcon,
                    )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                  child: Center(
                    child: Text(
                        "${controller.pendingRequestCount.value} Pending Requests",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        )),
                  ),
                )),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 24,
                  color: defaultAccentColor,
                ),
              ]),
            )
          : Container(),
    );
  }
}
