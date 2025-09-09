import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/work_log_request/controller/work_log_request_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

import '../../../../../utils/app_constants.dart';

class StartShiftBox extends StatelessWidget {
  StartShiftBox(
      {super.key,
      required this.title,
      required this.time,
      this.oldTime,
      required this.address,
      required this.timePickerType,
      this.status,
      this.onTap});

  final String title;
  final String time;
  final String? oldTime;
  final String address;
  final String timePickerType;
  final int? status;
  final GestureTapCallback? onTap;

  final controller = Get.put(WorkLogRequestController());

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
                color: backgroundColor_(context),
                borderColor: ThemeConfig.isDarkMode
                    ? Color(0xFF424242)
                    : Colors.grey.shade400,
                boxShadow: [AppUtils.boxShadow(shadowColor_(context), 6)],
                radius: 45),
            child: PrimaryTextView(
              textAlign: TextAlign.center,
              text: title,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: primaryTextColor_(context),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: (status ?? 0) == AppConstants.status.pending,
            child: PrimaryTextView(
              text: oldTime,
              color: primaryTextColor_(context),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Visibility(
              visible: (status ?? 0) == AppConstants.status.pending,
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 26,
                  color: Colors.grey,
                ),
              )),
          PrimaryTextView(
            text: time,
            color: primaryTextColor_(context),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }
}
