import 'package:belcka/pages/manage_forms/submit_form/controller/submit_form_controller.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormDateFieldView extends StatelessWidget {
  const FormDateFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitFormController>();
    final fieldId = field.id ?? '';

    return Obx(
      () {
        final value = controller.getDateValue(fieldId);
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
              if (field.includesDate) ...[
                const SizedBox(height: 12),
                _DateTimePickerRow(
                  icon: Icons.calendar_today_outlined,
                  displayText: value?.date != null
                      ? DateUtil.dateToString(
                          value!.date,
                          DateUtil.DD_MM_YYYY_SLASH,
                        )
                      : 'select_date'.tr,
                  isPlaceholder: value?.date == null,
                  onTap: () => controller.showFormDatePicker(fieldId),
                ),
              ],
              if (field.includesTime) ...[
                SizedBox(height: field.includesDate ? 10 : 12),
                _DateTimePickerRow(
                  icon: Icons.access_time,
                  displayText: value?.time != null
                      ? DateUtil.timeToString(
                          value!.time,
                          DateUtil.HH_MM_24,
                        )
                      : 'select_time'.tr,
                  isPlaceholder: value?.time == null,
                  onTap: () => controller.showFormTimePicker(fieldId),
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

class _DateTimePickerRow extends StatelessWidget {
  const _DateTimePickerRow({
    required this.icon,
    required this.displayText,
    required this.isPlaceholder,
    required this.onTap,
  });

  final IconData icon;
  final String displayText;
  final bool isPlaceholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: secondaryExtraLightTextColor_(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: isPlaceholder
                      ? secondaryExtraLightTextColor_(context)
                      : primaryTextColor_(context),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: secondaryExtraLightTextColor_(context),
            ),
          ],
        ),
      ),
    );
  }
}
