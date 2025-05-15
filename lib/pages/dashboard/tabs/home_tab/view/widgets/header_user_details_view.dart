import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/shapes/badge_count_widget.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class HeaderUserDetailsView extends StatelessWidget {
  const HeaderUserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(14, 20, 14, 0),
      decoration: AppUtils.getDashboardItemDecoration(
          borderWidth: 2, borderColor: dashBoardItemStrokeColor, radius: 20),
      padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                  border: Border.all(
                    width: 3,
                    color: Color(0xff1E1E1E),
                    style: BorderStyle.solid,
                  ),
                ),
                child: ImageUtils.setUserImage(
                  url: "https://i.pravatar.cc/150?img=3",
                  width: 50,
                  height: 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleWidget(color: Colors.green, width: 12, height: 12),
              )
            ],
          ),
          SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryTextView(
                  text: "Hi, Ramil",
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: primaryTextColorLight,
                  softWrap: true,
                ),
                PrimaryTextView(
                  text: "Monday, 17 Apr",
                  color: secondaryExtraLightTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  softWrap: true,
                )
              ],
            ),
          ),
          CustomBadgeIcon(
              child: ImageUtils.setSvgAssetsImage(
                  path: Drawable.bellIcon, width: 28, height: 28),
              count: 5)
        ],
      ),
    );
  }
}
