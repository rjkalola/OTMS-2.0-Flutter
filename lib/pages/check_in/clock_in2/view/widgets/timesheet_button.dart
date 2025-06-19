import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class TimesheetButton extends StatelessWidget {
  TimesheetButton(
      {super.key,
      required this.title,
      required this.imageAssetsPath,
      required this.imageWidth,
      required this.imageHeight});

  String title;
  String imageAssetsPath;
  double imageWidth, imageHeight;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        padding: EdgeInsets.fromLTRB(10, 14, 10, 14),
        decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [AppUtils.boxShadow(Colors.grey.shade200, 9)],
            border: Border.all(width: 0.5, color: dividerColor),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              child: Center(
                child: ImageUtils.setSvgAssetsImage(
                    path: imageAssetsPath,
                    width: imageWidth,
                    height: imageHeight,
                    color: primaryTextColor),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            PrimaryTextView(
              text: title,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: primaryTextColor,
            )
          ],
        ),
      ),
    );
  }
}
