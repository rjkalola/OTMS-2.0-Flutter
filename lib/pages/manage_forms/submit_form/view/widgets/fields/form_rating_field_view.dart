import 'package:belcka/pages/manage_forms/submit_form/controller/submit_form_controller.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormRatingFieldView extends StatelessWidget {
  const FormRatingFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  static const Color _selectedStarColor = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitFormController>();
    final fieldId = field.id ?? '';
    final starCount = field.ratingStars;
    final minLabel = field.ratingMinLabel ?? '';
    final maxLabel = field.ratingMaxLabel ?? '';
    final showLabels =
        !StringHelper.isEmptyString(minLabel) ||
        !StringHelper.isEmptyString(maxLabel);
    final unselectedStarColor = secondaryExtraLightTextColor_(context);

    return Obx(
      () {
        final selectedRating = controller.getRating(fieldId);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var index = 1; index <= starCount; index++)
                    _StarButton(
                      isSelected: index <= selectedRating,
                      selectedColor: _selectedStarColor,
                      unselectedColor: unselectedStarColor,
                      onTap: () => controller.setRating(fieldId, index),
                    ),
                ],
              ),
              if (showLabels) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SubtitleTextView(
                        text: minLabel,
                        fontSize: 13,
                        color: secondaryExtraLightTextColor_(context),
                        maxLine: 2,
                      ),
                    ),
                    Expanded(
                      child: SubtitleTextView(
                        text: maxLabel,
                        fontSize: 13,
                        color: secondaryExtraLightTextColor_(context),
                        maxLine: 2,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
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

class _StarButton extends StatelessWidget {
  const _StarButton({
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Icon(
          isSelected ? Icons.star : Icons.star_border,
          size: 32,
          color: isSelected ? selectedColor : unselectedColor,
        ),
      ),
    );
  }
}
