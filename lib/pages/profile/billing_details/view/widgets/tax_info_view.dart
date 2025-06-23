import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/profile/billing_details/controller/billing_details_controller.dart';
import 'package:otm_inventory/pages/profile/widgets/nin_text_field.dart';
import 'package:otm_inventory/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:otm_inventory/pages/profile/widgets/utr_text_field.dart';
import 'package:otm_inventory/pages/profile/widgets/name_on_utr_text_field.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';

class TaxInfoView extends StatelessWidget {
  TaxInfoView({super.key});

  final controller = Get.put(BillingDetailsController());

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
                  title: 'tax_info'.tr,
                ),
                NameOnUtrTextField(
                  controller: controller.nameOnUTRController,
                ),
                UtrTextField(
                  controller: controller.utrController,
                ),
                NINTextField(
                  controller: controller.ninController,
                ),
              ],
            ),
          )),
    );
  }
}
