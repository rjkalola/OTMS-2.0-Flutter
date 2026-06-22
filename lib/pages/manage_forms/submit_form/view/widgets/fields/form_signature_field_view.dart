import 'package:belcka/pages/manage_forms/submit_form/controller/submit_form_controller.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_field_label.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_signature_dialog.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_signature_pad.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormSignatureFieldView extends StatelessWidget {
  const FormSignatureFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  Future<void> _openSignatureDialog(
    BuildContext context,
    SubmitFormController controller,
    String fieldId,
  ) async {
    final result = await FormSignatureDialog.show(
      context: context,
      initialValue: controller.getSignatureValue(fieldId),
    );
    if (result != null) {
      controller.setSignatureValue(fieldId, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitFormController>();
    final fieldId = field.id ?? '';
    final accentColor = defaultAccentColor_(context);

    return Obx(
      () {
        final signatureValue = controller.getSignatureValue(fieldId);
        final hasSignature = signatureValue.isNotEmpty;
        final hasError = controller.showValidationErrors.value &&
            controller.isFieldInvalid(fieldId);

        return CardViewDashboardItem(
          borderRadius: isNested ? 12 : 16,
          margin: isNested
              ? const EdgeInsets.symmetric(horizontal: 4)
              : const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasSignature) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormFieldLabel(
                            label: field.label ?? '',
                            isRequired: field.isRequired,
                          ),
                          if (!StringHelper.isEmptyString(field.description)) ...[
                            const SizedBox(height: 4),
                            SubtitleTextView(
                              text: field.description!,
                              fontSize: 14,
                              color: secondaryExtraLightTextColor_(context),
                              maxLine: 4,
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.clearSignature(fieldId),
                      icon: Icon(
                        Icons.refresh,
                        color: secondaryExtraLightTextColor_(context),
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FormSignaturePad(
                  value: signatureValue,
                  readOnly: true,
                  height: 160,
                ),
              ] else ...[
                FormFieldLabel(
                  label: field.label ?? '',
                  isRequired: field.isRequired,
                ),
                if (!StringHelper.isEmptyString(field.description)) ...[
                  const SizedBox(height: 4),
                  SubtitleTextView(
                    text: field.description!,
                    fontSize: 14,
                    color: secondaryExtraLightTextColor_(context),
                    maxLine: 4,
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        _openSignatureDialog(context, controller, fieldId),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accentColor,
                      side: BorderSide(color: dividerColor_(context)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const StadiumBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.draw_outlined,
                          size: 18,
                          color: accentColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'click_to_sign'.tr,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (hasError && field.isRequired) ...[
                const SizedBox(height: 6),
                Text(
                  'this_field_is_required'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: rejectTextColor_(context),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
