import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_request/controller/billing_request_controller.dart';
import 'package:belcka/pages/profile/widgets/account_number_text_field.dart';
import 'package:belcka/pages/profile/widgets/bank_name_text_field.dart';
import 'package:belcka/pages/profile/widgets/name_on_account_text_field.dart';
import 'package:belcka/pages/profile/widgets/name_on_utr_text_field.dart';
import 'package:belcka/pages/profile/widgets/sort_code_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class BankDetailsFieldsView extends StatelessWidget {
  BankDetailsFieldsView({super.key});

  final controller = Get.put(BillingRequestController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: CardViewDashboardItem(
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                  title: 'bank_details'.tr,
                ),

                Visibility(
                  visible:(controller.billingRequestInfo.value.nameOnAccount ?? "").isNotEmpty,
                  child: NameOnAccountTextField(
                    controller: controller.nameOnAccountController,
                    isReadOnly: true,
                    isEnabled: false,
                  ),
                ),
                Visibility(
                  visible:(controller.billingRequestInfo.value.bankName ?? "").isNotEmpty,
                  child: BankNameTextField(
                    controller: controller.bankNameController,
                    isReadOnly: true,
                    isEnabled: false,
                  ),
                ),
                Visibility(
                  visible:(controller.billingRequestInfo.value.accountNo ?? "").isNotEmpty,
                  child: AccountNumberTextField(
                    controller: controller.accountNumberController,
                    isReadOnly: true,
                    isEnabled: false,
                  ),
                ),
                Visibility(
                  visible:(controller.billingRequestInfo.value.shortCode ?? "").isNotEmpty,
                  child: SortCodeTextField(
                    controller: controller.sortCodeController,
                    isReadOnly: true,
                    isEnabled: false,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}