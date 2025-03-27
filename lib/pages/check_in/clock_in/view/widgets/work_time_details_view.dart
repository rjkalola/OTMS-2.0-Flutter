import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class WorkTimeDetailsView extends StatelessWidget {
  const WorkTimeDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: dividerColor),
        borderRadius: BorderRadius.circular(8),
        color: Color(0xff659DF2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          PrimaryTextView(
            text: 'work_time_on'.tr,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          PrimaryTextView(
            text: "06:00:00",
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageUtils.setAssetsImage(Drawable.pinMapGoogleIcon, 24, 24,
                    BoxFit.cover, Colors.white),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: PrimaryTextView(
                    text:
                        "650, High road, Essex ,London IG80PU 650, High road, Essex ,London IG80PU",
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(0xff305BAB),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryTextView(
                  text: 'total_work_hour_today'.tr,
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                PrimaryTextView(
                  text: "07:00:00",
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )
              ],
            ),
          ),
          SizedBox(
              width: double.infinity,
              child:
                  PrimaryButton(buttonText: 'stop_work'.tr, onPressed: () {}))
        ],
      ),
    );
  }
}
