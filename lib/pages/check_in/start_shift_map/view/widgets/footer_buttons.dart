import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/start_shift_map/controller/start_shift_map_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../widgets/PrimaryButton.dart';

class FooterButtons extends StatelessWidget {
  FooterButtons({super.key});

  final controller = Get.put(StartShiftMapController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isMainViewVisible.value,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: PrimaryButton(
                      buttonText: 'start_shift'.tr,
                      height:
                          (controller.lastWorkLogData.value.projectId ?? 0) != 0
                              ? 60
                              : 48,
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
                ),
                Visibility(
                  visible:
                      (controller.lastWorkLogData.value.projectId ?? 0) != 0,
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                Visibility(
                  visible:
                      (controller.lastWorkLogData.value.projectId ?? 0) != 0,
                  child: Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        controller.userStartWorkApi();
                      },
                      child: Container(
                        decoration: AppUtils.getGrayBorderDecoration(
                            color: defaultAccentColor_(context), radius: 18),
                        padding: EdgeInsets.all(8),
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TitleTextView(
                              text: controller
                                      .lastWorkLogData.value.projectName ??
                                  "",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              maxLine: 1,
                            ),
                            TitleTextView(
                              text: "(${'continue_shift'.tr})",
                              color: Colors.white,
                              fontSize: 13,
                              maxLine: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
