import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/start_shift_map/controller/start_shift_map_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/shapes/CustomCupertinoSpinner.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

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
                margin: EdgeInsets.all(12),
                child: PrimaryButton(
                    buttonText: 'start_shift'.tr,
                    color: Colors.green,
                    borderRadius: 16,
                    onPressed: () {
                      Get.toNamed(AppRoutes.selectShiftScreen);
                      // controller.showSelectShiftDialog();
                    }),
              )
            : Container(
                width: double.infinity,
                padding: EdgeInsets.all(9),
                color: dashBoardBgColor,
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
