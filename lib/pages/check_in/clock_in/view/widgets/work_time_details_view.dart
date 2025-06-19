import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/stop_shift_button.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class WorkTimeDetailsView extends StatelessWidget {
  WorkTimeDetailsView({super.key});

  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: dividerColor),
        borderRadius: BorderRadius.circular(16),
        color: Color(0xffCE6700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 14,
          ),
          PrimaryTextView(
            text: 'work_time_on'.tr,
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          PrimaryTextView(
            text: "06:00:00",
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          /* Padding(
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
          ),*/
          Container(
            margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.fromLTRB(9, 5, 9, 5),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Color(0xff305BAB),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryTextView(
                  text: 'total_work_hours_today'.tr,
                  fontSize: 15,
                  color: Colors.white,
                ),
                PrimaryTextView(
                  text: "07:00:00",
                  fontSize: 15,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
