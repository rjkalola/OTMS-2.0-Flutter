import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/company_details/controller/company_details_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';

class TextFieldWorkingHours extends StatelessWidget {
  TextFieldWorkingHours({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFieldBorder(
        textEditingController: controller.workingHourController.value,
        hintText: 'working_hours'.tr,
        labelText: 'working_hours'.tr,
        maxLength: 5,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValueChange: (value) {},
        // isReadOnly: true,
        validator: MultiValidator([
          // RequiredValidator(errorText: 'Value is required'),
          PatternValidator(r'^\d+(\.\d+)?$', errorText: 'Enter a valid time'),
          DoubleLessThanValidator(),
        ]),
        onPressed: () {
          // controller.showTimePickerDialog(
          //     AppConstants.dialogIdentifier.selectWorkingHourTime,
          //     controller.workingHourTIme);
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
      ),
    );
  }
}

class DoubleLessThanValidator extends FieldValidator<String> {
  DoubleLessThanValidator({String errorText = 'Value must be less than 24'})
      : super(errorText);

  @override
  bool isValid(String? value) {
    if (value == null || value.isEmpty)
      return true; // Let RequiredValidator handle this
    final doubleVal = double.tryParse(value);
    return doubleVal != null && doubleVal <= 24;
  }
}
