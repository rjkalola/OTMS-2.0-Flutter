import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class WorkTimeDetailsView extends StatelessWidget {
  const WorkTimeDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: dividerColor_(context)),
        borderRadius: BorderRadius.circular(16),
        color: Color(0xff659DF2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 12,
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
            padding: const EdgeInsets.fromLTRB(20, 3, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageUtils.setSvgAssetsImage(
                    path: Drawable.pinMapGoogleIcon,
                    width: 24,
                    height: 24,
                    color: Colors.white),
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
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(0xff305BAB),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryTextView(
                  text: 'total_work_hours_today'.tr,
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                PrimaryTextView(
                  text: "07:00:00",
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )
              ],
            ),
          ),
          SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                buttonText: 'stop_work'.tr,
                onPressed: () {},
                color: Color(0xffFF6464),
                fontWeight: FontWeight.w700,
                fontSize: 16,
                borderRadius: 12,
              ))
        ],
      ),
    );
  }
}
