import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class StartShiftBox extends StatelessWidget {
  StartShiftBox(
      {super.key,
      required this.title,
      required this.time,
      required this.address,
      required this.timePickerType,
      this.onTap});

  final String title;
  final String time;
  final String address;
  final String timePickerType;
  final GestureTapCallback? onTap;

  final controller = Get.put(StopShiftController());

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
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PrimaryTextView(
                    text: time,
                    color: primaryTextColor_(context),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Visibility(
                      visible: !controller.isWorking.value &&
                          ((controller.workLogInfo.value.requestStatus ?? 0) ==
                                  0 ||
                              (controller.workLogInfo.value.requestStatus ??
                                      0) ==
                                  AppConstants.status.rejected),
                      child: ImageUtils.setSvgAssetsImage(
                          path: Drawable.editPencilIcon,
                          width: 13,
                          height: 13,
                          color: primaryTextColor_(context)))
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
