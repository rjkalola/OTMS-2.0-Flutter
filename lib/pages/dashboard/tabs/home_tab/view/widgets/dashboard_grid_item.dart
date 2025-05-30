import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class DashboardGridItem extends StatelessWidget {
  DashboardGridItem({super.key, required this.info, required this.index});

  PermissionInfo info;
  int index;
  final controller = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
        child: GestureDetector(
      onTap: () {
        controller.onClickPermission(index, info);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14, 12, 10, 12),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageUtils.setSvgAssetsImage(
                path: "${AppConstants.permissionIconsAssetsPath}${info.icon}",
                // path: Drawable.truckPermissionIcon,
                width: 26,
                height: 26,
                color: Color(AppUtils.haxColor(info.color ?? "#000000"))),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // !StringHelper.isEmptyString(info.title)
                  //     ? PrimaryTextView(
                  //         text: info.title ?? "",
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 14,
                  //         textAlign: TextAlign.center,
                  //         color: primaryTextColorLight,
                  //         softWrap: true,
                  //       )
                  //     : Container()
                  Visibility(
                    visible: !StringHelper.isEmptyString(info.name),
                    child: PrimaryTextView(
                      text: info.name ?? "",
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      color: primaryTextColorLight,
                      softWrap: true,
                      maxLine: 2,
                    ),
                  ),
                  Visibility(
                    visible: !StringHelper.isEmptyString(info.value),
                    child: PrimaryTextView(
                      text: info.value ?? "",
                      textAlign: TextAlign.center,
                      color: secondaryExtraLightTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      softWrap: true,
                      maxLine: 1,
                    ),
                  ),
                  // !StringHelper.isEmptyString(info.subTitle)
                  //     ? PrimaryTextView(
                  //         text: info.subTitle ?? "",
                  //         textAlign: TextAlign.center,
                  //         color: secondaryExtraLightTextColor,
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 14,
                  //         softWrap: true,
                  //       )
                  //     : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    /* return Container(
      height: 90,
      decoration: AppUtils.getDashboardItemDecoration(
          borderWidth: 0,
          borderColor: dashBoardItemStrokeColor,
          radius: 20,),
      padding: EdgeInsets.fromLTRB(14, 12, 10, 12),
      child: GestureDetector(
        onTap: () {
          controller.onClickPermission(index, info);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageUtils.setSvgAssetsImage(
                path: "${AppConstants.permissionIconsAssetsPath}${info.icon}",
                // path: Drawable.truckPermissionIcon,
                width: 26,
                height: 26),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // !StringHelper.isEmptyString(info.title)
                  //     ? PrimaryTextView(
                  //         text: info.title ?? "",
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 14,
                  //         textAlign: TextAlign.center,
                  //         color: primaryTextColorLight,
                  //         softWrap: true,
                  //       )
                  //     : Container()
                  Visibility(
                    visible: !StringHelper.isEmptyString(info.name),
                    child: PrimaryTextView(
                      text: info.name ?? "",
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      textAlign: TextAlign.center,
                      color: primaryTextColorLight,
                      softWrap: true,
                      maxLine: 2,
                    ),
                  ),
                  Visibility(
                    visible: !StringHelper.isEmptyString(info.value),
                    child: PrimaryTextView(
                      text: info.value ?? "",
                      textAlign: TextAlign.center,
                      color: secondaryExtraLightTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      softWrap: true,
                      maxLine: 1,
                    ),
                  ),
                  // !StringHelper.isEmptyString(info.subTitle)
                  //     ? PrimaryTextView(
                  //         text: info.subTitle ?? "",
                  //         textAlign: TextAlign.center,
                  //         color: secondaryExtraLightTextColor,
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 14,
                  //         softWrap: true,
                  //       )
                  //     : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );*/
  }
}
