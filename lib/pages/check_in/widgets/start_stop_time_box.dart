import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/controller/stop_shift_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class StartStopTimeBox extends StatelessWidget {
  StartStopTimeBox(
      {super.key,
      required this.title,
      required this.time,
      required this.address,
      required this.isEditVisible,
      this.onTap});

  final String title;
  final RxString time;
  final String address;
  final RxBool isEditVisible;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Flexible(
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
                      text: time.value,
                      color: primaryTextColor_(context),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Visibility(
                        visible: isEditVisible.value,
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
      ),
    );
  }
}
