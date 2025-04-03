import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class FooterStatusView extends StatelessWidget {
  const FooterStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 8),
      // color: Color(AppUtils.haxColor("#E7E7E7")),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(AppUtils.haxColor("#E7E7E7")),
      ),
      child: Row(
        children: [
          statusView(
              Color(AppUtils.haxColor("#FF6464")), 'ready_to_start_work'.tr, 3),
          statusView(Color(AppUtils.haxColor("#FFDC4A")), 'in_progress'.tr, 2),
          statusView(Color(AppUtils.haxColor("#2DC75C")), 'completed'.tr, 2)
        ],
      ),
    );
  }

  Widget statusView(Color color, String title, int flex) => Flexible(
        flex: flex,
        fit: FlexFit.tight,
        child: Row(
          children: [
            CircleWidget(color: color, width: 16, height: 16),
            SizedBox(
              width: 6,
            ),
            PrimaryTextView(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: primaryTextColor,
              softWrap: true,
              text: title,
            )
          ],
        ),
      );
}
