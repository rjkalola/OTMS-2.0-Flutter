import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:belcka/pages/company/company_signup/controller/company_signup_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:get/get.dart';

class HeadOfficeLocationViewCompanySignup extends StatelessWidget {
  HeadOfficeLocationViewCompanySignup({super.key});

  final controller = Get.put(CompanySignUpController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Row(
        children: [
          Expanded(
            child: TextFieldBorder(
              textEditingController: controller.locationController.value,
              hintText: 'head_office_location'.tr,
              labelText: 'head_office_location'.tr,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onValueChange: (value) {},
              validator: MultiValidator([
                RequiredValidator(errorText: 'required_field'.tr),
              ]),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          ImageUtils.setSvgAssetsImage(
              path: Drawable.myLocationIcon,
              width: 22,
              height: 22,
              color: defaultAccentColor_(context))
        ],
      ),
    );
  }
}
