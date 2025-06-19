import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/account_number_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/bank_name_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/name_on_account_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/name_on_utr_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/sort_code_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class BankDetailsView extends StatelessWidget {
  const BankDetailsView({super.key});

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
            NameOnAccountTextField(),
            BankNameTextField(),
            AccountNumberTextField(),
            SortCodeTextField(),
          ],
        ),
      )),
    );
  }
}
