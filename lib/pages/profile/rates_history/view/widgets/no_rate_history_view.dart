import 'package:belcka/pages/profile/rates_history/controller/rates_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoRateHistoryView extends StatelessWidget {
  NoRateHistoryView({super.key});
  final controller = Get.put(RatesHistoryController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400), // Optional icon
          const SizedBox(height: 16),
          Text(
            "No Rate History Found",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}