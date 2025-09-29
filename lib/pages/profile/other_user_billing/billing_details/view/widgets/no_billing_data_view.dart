import 'package:belcka/pages/profile/other_user_billing/billing_details/controller/other_user_billing_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NoBillingDataView extends StatelessWidget {
  NoBillingDataView({super.key});
  final controller = Get.put(OtherUserBillingDetailsController());
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400), // Optional icon
          const SizedBox(height: 16),
          Text(
            'no_billing_info_available'.tr,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}