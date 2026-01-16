import 'package:belcka/pages/company/company_details/controller/company_details_controller.dart';
import 'package:belcka/widgets/textfield/text_field_border_dark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class TextFieldCompanyWebsite extends StatelessWidget {
  TextFieldCompanyWebsite({super.key});

  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFieldBorderDark(
          textEditingController: controller.companyWebsiteController.value,
          hintText: 'company_website'.tr,
          labelText: 'company_website'.tr,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onValueChange: (value) {},
          validator: MultiValidator([]),
          inputFormatters: <TextInputFormatter>[
            // for below version 2 use this
            FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9:/?&=._\-#]+')),
          ]),
    );
  }

  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.isScheme('http') || uri.isScheme('https'));
  }
}
