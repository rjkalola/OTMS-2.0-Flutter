import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckInSettingsBottomSheet extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onSave;
  final VoidCallback onCancel;

  const CheckInSettingsBottomSheet({
    super.key,
    required this.initialValue,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<CheckInSettingsBottomSheet> createState() =>
      _CheckInSettingsBottomSheetState();
}

class _CheckInSettingsBottomSheetState extends State<CheckInSettingsBottomSheet> {
  late bool _isCheckIn;

  @override
  void initState() {
    super.initState();
    _isCheckIn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: PrimaryTextView(
                  text: 'check_in_'.tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomSwitch(
                onValueChange: (value) {
                  setState(() {
                    _isCheckIn = value;
                  });
                },
                mValue: _isCheckIn,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: PrimaryBorderButton(
                  buttonText: 'cancel'.tr,
                  fontColor: secondaryLightTextColor_(context),
                  borderColor: secondaryTextColor_(context),
                  fontWeight: FontWeight.w400,
                  onPressed: widget.onCancel,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  buttonText: 'save'.tr,
                  onPressed: () {
                    widget.onSave(_isCheckIn);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
