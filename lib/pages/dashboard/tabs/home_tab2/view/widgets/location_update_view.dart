import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';

class LocationUpdateView extends StatelessWidget {
  final controller = Get.put(HomeTabController());

  LocationUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isUpdateLocationVisible.value
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
                            Text(
                                controller.dashboardResponse.value
                                        .userUpdateLocationCount ??
                                    "",
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
                        controller.isNextUpdateLocationTimeVisible.value
                            ? SizedBox(
                                height: 3,
                              )
                            : Container(),
                        controller.isNextUpdateLocationTimeVisible.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(controller.updateLocationTime.value,
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
                              )
                            : Container(),
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
            )
          : Container(),
    );
  }
}
