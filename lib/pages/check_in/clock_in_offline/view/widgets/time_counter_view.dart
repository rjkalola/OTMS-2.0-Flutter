import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeCounterView extends StatelessWidget {
  const TimeCounterView({super.key, required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: dividerColor_(context)),
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xff007AFF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          PrimaryTextView(
            text: 'work_time_on'.tr,
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          PrimaryTextView(
            text: time,
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
