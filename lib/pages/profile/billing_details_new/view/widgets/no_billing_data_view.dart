import 'package:belcka/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:belcka/pages/profile/billing_details_new/controller/billing_details_new_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';

class NoBillingDataView extends StatelessWidget {
  NoBillingDataView({super.key});
  final controller = Get.put(BillingDetailsNewController());
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
          ElevatedButton(
            onPressed: () {
              // Navigate to add billing info screen or show form
              var arguments = {
                AppConstants.intentKey.billingInfo: controller.billingInfo.value,
                AppConstants.intentKey.userId : controller.userId
              };
              controller.moveToScreen(AppRoutes.billingInfoScreen, arguments);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: defaultAccentColor_(context),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'add_billing_info'.tr,
              style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}