import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_details_new/controller/billing_details_new_controller.dart';
import 'package:belcka/pages/profile/billing_info/controller/billing_info_controller.dart';
import 'package:belcka/pages/profile/widgets/account_number_text_field.dart';
import 'package:belcka/pages/profile/widgets/bank_name_text_field.dart';
import 'package:belcka/pages/profile/widgets/name_on_account_text_field.dart';
import 'package:belcka/pages/profile/widgets/name_on_utr_text_field.dart';
import 'package:belcka/pages/profile/widgets/sort_code_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class BankDetailsView extends StatelessWidget {
   BankDetailsView({super.key});

  final controller = Get.put(BillingDetailsNewController());

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
            NameOnAccountTextField(
              controller: controller.nameOnAccountController,
              isReadOnly: true,
              isEnabled: false,
            ),
            BankNameTextField(
              controller: controller.bankNameController,
              isReadOnly: true,
              isEnabled: false,
            ),
            AccountNumberTextField(
              controller: controller.accountNumberController,
              isReadOnly: true,
              isEnabled: false,
            ),
            SortCodeTextField(
              controller: controller.sortCodeController,
              isReadOnly: true,
              isEnabled: false,
            ),
          ],
        ),
      )),
    );
  }
}
