import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/widgets/PrimaryButton.dart';

class ApproveRejectButtons extends StatelessWidget {
  ApproveRejectButtons(
      {super.key,
      this.padding,
      required this.onClickReject,
      required this.onClickApprove,
      this.approveTitle,
      this.rejectTitle,
      this.fontSize});

  final EdgeInsetsGeometry? padding;
  final VoidCallback onClickReject, onClickApprove;
  final String? approveTitle, rejectTitle;
  final double? fontSize;

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
              buttonText: rejectTitle ?? 'reject'.tr,
              color: Colors.red,
              onPressed: onClickReject,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: PrimaryButton(
                buttonText: approveTitle ?? 'approve'.tr,
                onPressed: onClickApprove,
                fontSize: fontSize,
              )),
        ],
      ),
    );
  }
}
