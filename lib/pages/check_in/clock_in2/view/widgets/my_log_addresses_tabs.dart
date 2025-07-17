import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class MyLogAddressesTabs extends StatelessWidget {
  const MyLogAddressesTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
            border: Border.all(width: 0.6, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: backgroundColor_(context),
            boxShadow: [AppUtils.boxShadow(Colors.grey.shade300, 6)]),
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: PrimaryButton(
                buttonText: 'my_day_log'.tr,
                onPressed: () {},
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontColor: primaryTextColor_(context),
                borderRadius: 11,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: PrimaryButton(
                buttonText: 'check_in_addresses'.tr,
                onPressed: () {},
                color: Color(0xffE6EAF0),
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontColor: primaryTextColor_(context),
                borderRadius: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
