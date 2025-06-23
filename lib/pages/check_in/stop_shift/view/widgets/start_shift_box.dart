import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class StartShiftBox extends StatelessWidget {
  StartShiftBox(
      {super.key,
      required this.title,
      required this.time,
      required this.address});

  final String title;
  final String time;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: CardViewDashboardItem(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 6,
              bottom: 6,
            ),
            decoration: AppUtils.getGrayBorderDecoration(
                color: backgroundColor,
                borderColor: Colors.grey.shade400,
                boxShadow: [AppUtils.boxShadow(Colors.grey.shade300, 6)],
                radius: 45),
            child: PrimaryTextView(
              textAlign: TextAlign.center,
              text: title,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: primaryTextColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryTextView(
                  text: time,
                  color: primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  width: 10,
                ),
                ImageUtils.setSvgAssetsImage(
                    path: Drawable.editPencilIcon, width: 13, height: 13)
              ],
            ),
          ),
          /*Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
              decoration: AppUtils.getGrayBorderDecoration(
                  color: backgroundColor,
                  borderColor: Colors.grey.shade300,
                  radius: 9),
              child: Row(
                children: [
                  ImageUtils.setSvgAssetsImage(
                      path: Drawable.locationMapNavigationPointer,
                      width: 18,
                      height: 18),
                  SizedBox(
                    width: 6,
                  ),
                  Flexible(
                    child: PrimaryTextView(
                      textAlign: TextAlign.start,
                      text: address,
                      color: primaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),*/
        ],
      )),
    );
  }
}
