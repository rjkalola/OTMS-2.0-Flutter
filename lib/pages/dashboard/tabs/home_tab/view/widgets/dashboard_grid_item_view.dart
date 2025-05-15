import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/dashboard_grid_item_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/shapes/badge_count_widget.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class DashboardGridItemView extends StatelessWidget {
  DashboardGridItemView({super.key, required this.info});

  DashboardGridItemInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppUtils.getDashboardItemDecoration(
          borderWidth: 2, borderColor: dashBoardItemStrokeColor, radius: 20),
      padding: EdgeInsets.fromLTRB(9, 12, 9, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageUtils.setAssetsImage(
              path: Drawable.timeClockImageTemp, width: 32, height: 32),
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
                  visible: !StringHelper.isEmptyString(info.title),
                  child: PrimaryTextView(
                    text: info.title ?? "",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    textAlign: TextAlign.center,
                    color: primaryTextColorLight,
                    softWrap: true,
                  ),
                ),
                Visibility(
                  visible: !StringHelper.isEmptyString(info.subTitle),
                  child: PrimaryTextView(
                    text: info.subTitle ?? "",
                    textAlign: TextAlign.center,
                    color: secondaryExtraLightTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    softWrap: true,
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
    );
  }
}
