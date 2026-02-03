import 'package:belcka/pages/company/joincompany/view/widgets/company_details_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/textfield/text_field_border.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SelectTradeJoinCompany extends StatelessWidget {
  SelectTradeJoinCompany({
    super.key,
  });

  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.fromLTRB(20, 30, 20, 10),
        padding: EdgeInsets.fromLTRB(16, 30, 16, 24),
        width: double.infinity,
        decoration: AppUtils.getGrayBorderDecoration(
          borderColor: Colors.grey.shade300,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CompanyDetailsWidget(),
            SizedBox(height: 24,),
            TextFieldBorder(
                textEditingController:
                    controller.selectYourRoleController.value,
                hintText: 'select_your_trade'.tr,
                labelText: 'select_your_trade'.tr,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                isReadOnly: true,
                suffixIcon: const Icon(Icons.arrow_drop_down),
                validator: MultiValidator([]),
                onPressed: () {
                  controller.showTradeList();
                }),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                    buttonText: 'confirm'.tr,
                    fontWeight: FontWeight.w400,
                    onPressed: () {
                      // if (controller.tradeId != 0) {
                        // controller.storeTradeApi();
                        controller.joinCompanyApi();
                      // } else {
                      //   AppUtils.showToastMessage('please_select_trade'.tr);
                      // }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
