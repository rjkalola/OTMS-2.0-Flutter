import 'package:belcka/pages/manage_forms/submit_form/model/form_signature_value.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_signature_pad.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormSignatureDialog extends StatefulWidget {
  const FormSignatureDialog({
    super.key,
    this.initialValue,
  });

  final FormSignatureValue? initialValue;

  static const Color _dialogBackground = Colors.white;
  static const Color _titleColor = Color(0xFF1A1A1A);
  static const Color _mutedColor = Color(0xFF737373);
  static const Color _buttonBorderColor = Color(0xFFE0E0E0);

  static Future<FormSignatureValue?> show({
    required BuildContext context,
    FormSignatureValue? initialValue,
  }) {
    return showDialog<FormSignatureValue>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => FormSignatureDialog(initialValue: initialValue),
    );
  }

  @override
  State<FormSignatureDialog> createState() => _FormSignatureDialogState();
}

class _FormSignatureDialogState extends State<FormSignatureDialog> {
  late FormSignatureValue _draftValue;
  int _resetToken = 0;

  @override
  void initState() {
    super.initState();
    _draftValue = widget.initialValue?.copy() ?? FormSignatureValue();
  }

  void _onDraftChanged(FormSignatureValue value) {
    setState(() {
      _draftValue = value;
    });
  }

  void _resetPad() {
    setState(() {
      _resetToken++;
      _draftValue = FormSignatureValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = defaultAccentColor_(context);
    final padValue = _resetToken == 0
        ? _draftValue
        : FormSignatureValue();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: FormSignatureDialog._dialogBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 36,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'sign'.tr,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: FormSignatureDialog._titleColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            size: 22,
                            color: FormSignatureDialog._mutedColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: FormSignaturePad.canvasWrapperColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: FormSignaturePad(
                key: ValueKey(_resetToken),
                value: padValue,
                onChanged: _onDraftChanged,
                height: 220,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _resetPad,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FormSignatureDialog._titleColor,
                    backgroundColor: FormSignatureDialog._dialogBackground,
                    side: const BorderSide(
                      color: FormSignatureDialog._buttonBorderColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'reset'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _draftValue.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(_draftValue),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        accentColor.withValues(alpha: 0.35),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'confirm'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
