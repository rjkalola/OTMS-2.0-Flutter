import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:otm_inventory/pages/profile/billing_request/controller/billing_request_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';

class NoBillingRequestDataView extends StatelessWidget {
  NoBillingRequestDataView({super.key});
  final controller = Get.put(BillingRequestController());
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400), // Optional icon
          const SizedBox(height: 16),
          Text(
            'No Billing Info Available',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to add billing info screen or show form
              //controller.moveToScreen(AppRoutes.billingInfoScreen, null);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: blueBGButtonColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Add Billing Info',
              style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}