import 'package:belcka/buyer_app/generate_report/controller/generate_report_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerateReportExportBottomSheet extends StatelessWidget {
  const GenerateReportExportBottomSheet({super.key, required this.controller});

  final GenerateReportController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: constraints.maxHeight * 0.85),
            child: Container(
              decoration: BoxDecoration(
                color: dashBoardBgColor_(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => TitleTextView(
                            text: controller.sheetTitle.value,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          )),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: controller.pickDateRange,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: normalTextFieldBorderDarkColor_(context)),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 20,
                                  color: defaultAccentColor_(context)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Obx(() => TitleTextView(
                                      text:
                                          '${controller.sheetStartDate.value} ~ ${controller.sheetEndDate.value}',
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: controller.showModulesDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: normalTextFieldBorderDarkColor_(context),
                                width: 1.2),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Row(
                            children: [
                              Expanded( 
                                child: Obx(() => TitleTextView(
                                      text: controller.sheetModuleDisplayText
                                              .value.isEmpty
                                          ? controller.getSelectModuleTitle(
                                              controller
                                                  .sheetReportTypeKey.value)
                                          : controller
                                              .sheetModuleDisplayText.value,
                                    )),
                              ),
                              Icon(Icons.keyboard_arrow_down,
                                  color: defaultAccentColor_(context)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: PrimaryBorderButton(
                              buttonText: 'cancel'.tr,
                              fontColor: Colors.red,
                              borderColor: Colors.red,
                              onPressed: () => Get.back(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            fit: FlexFit.tight,
                            child: PrimaryButton(
                              buttonText: 'export_report'.tr,
                              onPressed: controller.exportReport,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
