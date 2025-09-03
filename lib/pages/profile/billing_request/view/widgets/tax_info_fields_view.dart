import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/profile/billing_request/controller/billing_request_controller.dart';
import 'package:belcka/pages/profile/widgets/nin_text_field.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/title_text.dart';
import 'package:belcka/pages/profile/widgets/utr_text_field.dart';
import 'package:belcka/pages/profile/widgets/name_on_utr_text_field.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

class TaxInfoFieldsView extends StatelessWidget {
  TaxInfoFieldsView({super.key});

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
                  title: 'tax_info'.tr,
                ),
                Visibility(
                  visible: (controller.billingRequestInfo.value.nameOnUtr ?? "").isNotEmpty,
                  child: NameOnUtrTextField(
                    controller: controller.nameOnUTRController,
                    isReadOnly: true,
                    isEnabled: false,
                  ),
                ),

                Visibility(
                  visible: (controller.billingRequestInfo.value.utrNumber ?? "").isNotEmpty,
                  child: UtrTextField(
                    controller: controller.utrController,
                    isReadOnly: true,
                    isEnabled: false,
                  ),
                ),
                Visibility(
                  visible: (controller.billingRequestInfo.value.ninNumber ?? "").isNotEmpty,
                  child: NINTextField(
                    controller: controller.ninController,
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