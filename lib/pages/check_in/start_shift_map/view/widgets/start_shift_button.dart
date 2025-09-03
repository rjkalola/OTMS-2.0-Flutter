import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/start_shift_map/controller/start_shift_map_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/shapes/CustomCupertinoSpinner.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class StartShiftButton extends StatelessWidget {
  StartShiftButton({super.key});

  final controller = Get.put(StartShiftMapController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Align(
        alignment: Alignment.bottomCenter,
        child: controller.isLocationLoaded.value
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 14,right: 14),
                child: PrimaryButton(
                    buttonText: 'start_shift'.tr,
                    color: Colors.green,
                    borderRadius: 20,
                    onPressed: () {
                      var arguments = {
                        AppConstants.intentKey.fromStartShiftScreen: true,
                      };
                      Get.offNamed(AppRoutes.selectProjectScreen,
                          arguments: arguments);
                      // controller.showSelectShiftDialog();
                    }),
              )
            : Container(
                width: double.infinity,
                padding: EdgeInsets.all(9),
                color: dashBoardBgColor_(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomCupertinoSpinner(radius: 12, color: Colors.grey),
                    SizedBox(
                      width: 10,
                    ),
                    TitleTextView(
                      text: "Location Loading...",
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
