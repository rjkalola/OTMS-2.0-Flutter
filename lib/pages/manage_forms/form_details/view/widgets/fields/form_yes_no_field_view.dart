import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormYesNoFieldView extends StatelessWidget {
  const FormYesNoFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  List<String> get _options => field.yesNoOptions;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final fieldId = field.id ?? '';
    final accentColor = defaultAccentColor_(context);

    return Obx(
      () {
        final selected = controller.getSingleSelection(fieldId);
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
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  for (final option in _options)
                    _YesNoPillButton(
                      label: option,
                      isSelected: selected == option,
                      accentColor: accentColor,
                      onTap: () => controller.setSingleSelection(fieldId, option),
                    ),
                ],
              ),
              if (hasError && field.isRequired) ...[
                const SizedBox(height: 8),
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

class _YesNoPillButton extends StatelessWidget {
  const _YesNoPillButton({
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? accentColor.withValues(alpha: 0.12)
            : Colors.white,
        foregroundColor: isSelected ? accentColor : primaryTextColor_(context),
        side: BorderSide(
          color: isSelected ? accentColor : dividerColor_(context),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(label),
    );
  }
}
