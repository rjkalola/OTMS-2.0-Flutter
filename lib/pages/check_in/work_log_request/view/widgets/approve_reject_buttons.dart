import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';

class ApproveRejectButtons extends StatelessWidget {
  ApproveRejectButtons(
      {super.key,
      this.padding,
      required this.onClickReject,
      required this.onClickApprove});

  final EdgeInsetsGeometry? padding;
  final VoidCallback onClickReject, onClickApprove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: PrimaryButton(
              buttonText: 'reject'.tr,
              color: Colors.red,
              onPressed: onClickReject,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: PrimaryButton(
                buttonText: 'approve'.tr,
                onPressed: onClickApprove,
              )),
        ],
      ),
    );
  }
}
