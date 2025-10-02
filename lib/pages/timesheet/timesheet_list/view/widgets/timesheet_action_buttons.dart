import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/timesheet_list_controller.dart';

class TimeSheetActionButtons extends StatelessWidget {
  TimeSheetActionButtons({super.key});

  final controller = Get.put(TimeSheetListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isEditStatusEnable.value,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            margin: EdgeInsets.only(top: 9),
            color: backgroundColor_(context),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      print("Lock Click");
                      String statusIds = controller.getStatusIds();
                      print("statusIds:" + statusIds);
                      if (!StringHelper.isEmptyString(statusIds)) {
                        controller.changeTimesheetStatusApi(
                            statusIds, AppConstants.action.lock);
                      }
                    },
                    child: TitleTextView(
                      text: 'lock'.tr,
                      textAlign: TextAlign.center,
                      color: Colors.green,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: dividerColor_(context),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      print("Unlock Click");
                      String statusIds = controller.getStatusIds();
                      print("statusIds:" + statusIds);
                      if (!StringHelper.isEmptyString(statusIds)) {
                        controller.changeTimesheetStatusApi(
                            statusIds, AppConstants.action.unlock);
                      }
                    },
                    child: TitleTextView(
                      text: 'unlock'.tr,
                      textAlign: TextAlign.center,
                      color: Colors.red,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: dividerColor_(context),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      print("Mark as paid Click");
                      String statusIds = controller.getStatusIds();
                      print("statusIds:" + statusIds);
                      if (!StringHelper.isEmptyString(statusIds)) {
                        controller.changeTimesheetStatusApi(
                            statusIds, AppConstants.action.markAsPaid);
                      }
                    },
                    child: TitleTextView(
                      text: 'mark_as_paid'.tr,
                      textAlign: TextAlign.center,
                      color: defaultAccentColor_(context),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  /* () => Visibility(
        visible: controller.isEditEnable.value ||
            controller.isEditStatusEnable.value,
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
      ),*/

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
