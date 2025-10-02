import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/timesheet_list_controller.dart';

class TimeSheetArchiveButton extends StatelessWidget {
  TimeSheetArchiveButton({super.key});

  final controller = Get.put(TimeSheetListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isEditEnable.value,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: PrimaryButton(
                      buttonText: getButtonTitle(),
                      onPressed: () {
                        if (controller.selectedAction ==
                            AppConstants.action.archive) {
                          String checkedIds = controller.getCheckedIds();
                          if (!StringHelper.isEmptyString(checkedIds)) {
                            controller.archiveTimesheetApi(checkedIds);
                          }
                        } else if (controller.selectedAction ==
                                AppConstants.action.lock ||
                            controller.selectedAction ==
                                AppConstants.action.unlock ||
                            controller.selectedAction ==
                                AppConstants.action.markAsPaid) {
                          String statusIds = controller.getStatusIds();
                          print("statusIds:" + statusIds);
                          controller.changeTimesheetStatusApi(
                              statusIds, controller.selectedAction);
                        }
                      }),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  flex: 1,
                  child: PrimaryBorderButton(
                      buttonText: 'cancel'.tr,
                      borderColor: secondaryLightTextColor_(context),
                      fontColor: secondaryLightTextColor_(context),
                      onPressed: () {
                        controller.unCheckAll();
                        controller.isEditEnable.value = false;
                        controller.isEditStatusEnable.value = false;
                      }),
                )
              ],
            ),
          ),
        ));
  }

  String getButtonTitle() {
    String title = "";
    if (controller.selectedAction == AppConstants.action.archive) {
      title = 'archive'.tr;
    } else if (controller.selectedAction == AppConstants.action.lock) {
      title = 'lock'.tr;
    } else if (controller.selectedAction == AppConstants.action.unlock) {
      title = 'unlock'.tr;
    } else if (controller.selectedAction == AppConstants.action.markAsPaid) {
      title = 'mark_as_paid'.tr;
    }
    return title;
  }
}
