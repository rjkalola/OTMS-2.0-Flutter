import 'package:belcka/pages/leaves/add_leave/controller/create_leave_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class AllDayOffView extends StatelessWidget {
  final controller = Get.put(CreateLeaveController());

  AllDayOffView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !controller.isAllDay.value,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 25),
          child: Column(
            children: [
              DropDownTextField(
                title: 'select_date'.tr,
                controller: controller.dateController,
                validators: [
                  if (!controller.isAllDay.value)
                    RequiredValidator(errorText: 'required_field'.tr),
                ],
                onPressed: () {
                  final DateTime today = DateTime.now();

                  final DateTime firstDate =
                      DateTime(today.year - 1, today.month, today.day);

                  final DateTime lastDate =
                      DateTime(today.year + 1, today.month, today.day);

                  controller.showDatePickerDialog(
                      AppConstants.dialogIdentifier.selectDate,
                      controller.selectDate,
                      firstDate,
                      lastDate);
                },
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: DropDownTextField(
                      title: 'start_time'.tr,
                      controller: controller.startTimeController,
                      validators: [
                        if (!controller.isAllDay.value)
                          RequiredValidator(errorText: 'required_field'.tr),
                      ],
                      onPressed: () {
                        controller.showTimePickerDialog(
                            AppConstants.dialogIdentifier.selectShiftStartTime,
                            controller.startTime);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Flexible(
                    flex: 1,
                    child: DropDownTextField(
                      title: 'end_time'.tr,
                      controller: controller.endTimeController,
                      validators: [
                        if (!controller.isAllDay.value)
                          RequiredValidator(errorText: 'required_field'.tr),
                      ],
                      onPressed: () {
                        controller.showTimePickerDialog(
                            AppConstants.dialogIdentifier.selectShiftEndTime,
                            controller.endTime);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
