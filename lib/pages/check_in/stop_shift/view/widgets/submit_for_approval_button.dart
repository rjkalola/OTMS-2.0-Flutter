import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
class SubmitForApprovalButton extends StatelessWidget {
  const SubmitForApprovalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
      child: PrimaryButton(
        buttonText: 'submit_for_approval'.tr,
        onPressed: () {},
      ),
    );
  }
}
