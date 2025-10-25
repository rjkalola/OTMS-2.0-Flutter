import 'package:belcka/pages/leaves/add_leave/controller/create_leave_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class AllDayOnView extends StatelessWidget {
  final controller = Get.put(CreateLeaveController());

  AllDayOnView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isAllDay.value,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 25),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: DropDownTextField(
                  title: 'start_date'.tr,
                  controller: controller.startDateController,
                  validators: [
                    if (controller.isAllDay.value)
                      RequiredValidator(errorText: 'required_field'.tr),
                  ],
                  onPressed: () {
                    controller.showDatePickerDialog(
                        AppConstants.dialogIdentifier.startDate,
                        controller.startDate,
                        DateTime.now(),
                        DateTime(2100));
                  },
                ),
              ),
              SizedBox(
                width: 14,
              ),
              Flexible(
                flex: 1,
                child: DropDownTextField(
                  title: 'end_date'.tr,
                  controller: controller.endDateController,
                  validators: [
                    if (controller.isAllDay.value)
                      RequiredValidator(errorText: 'required_field'.tr),
                  ],
                  onPressed: () {
                    controller.showDatePickerDialog(
                        AppConstants.dialogIdentifier.endDate,
                        controller.endDate,
                        DateTime.now(),
                        DateTime(2100));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
