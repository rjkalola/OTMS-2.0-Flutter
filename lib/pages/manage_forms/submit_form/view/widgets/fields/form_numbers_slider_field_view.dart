import 'package:belcka/pages/manage_forms/submit_form/controller/submit_form_controller.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormNumbersSliderFieldView extends StatelessWidget {
  const FormNumbersSliderFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  static const double _thumbRadius = 10;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitFormController>();
    final fieldId = field.id ?? '';
    final min = field.sliderMin;
    final max = field.sliderMax;
    final divisions = (max - min).round().clamp(1, 10000);
    final accentColor = defaultAccentColor_(context);
    final inactiveTrackColor = secondaryExtraLightTextColor_(context);

    return Obx(
      () {
        final currentValue = controller.getSliderValue(fieldId, field);
        final displayValue = _formatSliderValue(currentValue);
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
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  activeTrackColor: accentColor,
                  inactiveTrackColor: inactiveTrackColor.withValues(alpha: 0.35),
                  thumbColor: accentColor,
                  overlayColor: accentColor.withValues(alpha: 0.16),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: _thumbRadius,
                  ),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _thumbRadius),
                  child: Slider(
                    padding: EdgeInsets.zero,
                    value: currentValue.clamp(min, max),
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: (value) =>
                        controller.setSliderValue(fieldId, value),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${'value'.tr}: $displayValue',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: secondaryExtraLightTextColor_(context),
                ),
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

  String _formatSliderValue(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toString();
  }
}
