import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
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
                    color: primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Visibility(
                      visible: !controller.isWorking.value &&
                          !(controller.workLogInfo.value.isRequestPending ??
                              false),
                      child: ImageUtils.setSvgAssetsImage(
                          path: Drawable.editPencilIcon, width: 13, height: 13))
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
