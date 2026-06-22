import 'package:belcka/pages/manage_forms/submit_form/controller/submit_form_controller.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormDropdownFieldView extends StatelessWidget {
  const FormDropdownFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmitFormController>();
    final options = field.options ?? [];
    final fieldId = field.id ?? '';

    return Obx(
      () {
        final hasError =
            controller.showValidationErrors.value &&
                controller.isFieldInvalid(fieldId);

        return CardViewDashboardItem(
          borderRadius: isNested ? 12 : 16,
          margin: isNested
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
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
              const SizedBox(height: 8),
              if (field.multipleSelection == true)
                _CheckboxOptions(
                  fieldId: fieldId,
                  options: options,
                  controller: controller,
                )
              else
                _RadioOptions(
                  fieldId: fieldId,
                  options: options,
                  controller: controller,
                ),
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

class _OptionRowLayout {
  static const double itemSpacing = 8;
  static const double controlSize = 22;
  static const double radioTextGap = 4;
  static const double checkboxTextGap = 0;
  static const double radioLeadingInset = -6;
  static const double checkboxLeadingInset = -6;
}

class _RadioOptions extends StatelessWidget {
  const _RadioOptions({
    required this.fieldId,
    required this.options,
    required this.controller,
  });

  final String fieldId;
  final List<String> options;
  final SubmitFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RadioGroup<String>(
        groupValue: controller.getSingleSelection(fieldId),
        onChanged: (value) => controller.setSingleSelection(fieldId, value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) const SizedBox(height: _OptionRowLayout.itemSpacing),
              InkWell(
                onTap: () => controller.setSingleSelection(fieldId, options[i]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 4,),
                    Transform.translate(
                      offset: const Offset(_OptionRowLayout.radioLeadingInset, 0),
                      child: SizedBox(
                        width: _OptionRowLayout.controlSize,
                        height: _OptionRowLayout.controlSize,
                        child: Radio<String>(
                          value: options[i],
                          activeColor: defaultAccentColor_(context),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: _OptionRowLayout.radioTextGap),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          options[i],
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryTextColor_(context),
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CheckboxOptions extends StatelessWidget {
  const _CheckboxOptions({
    required this.fieldId,
    required this.options,
    required this.controller,
  });

  final String fieldId;
  final List<String> options;
  final SubmitFormController controller;

  @override
  Widget build(BuildContext context) {
    final compactTheme = Theme.of(context).copyWith(
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(height: _OptionRowLayout.itemSpacing),
            InkWell(
              onTap: () =>
                  controller.toggleMultipleSelection(fieldId, options[i]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 5),
                  Transform.translate(
                    offset: const Offset(
                      _OptionRowLayout.checkboxLeadingInset,
                      0,
                    ),
                    child: SizedBox(
                      width: _OptionRowLayout.controlSize,
                      height: _OptionRowLayout.controlSize,
                      child: Theme(
                        data: compactTheme,
                        child: Transform.scale(
                          scale: 0.9,
                          alignment: Alignment.centerLeft,
                          child: Checkbox(
                            value: controller.isMultipleSelected(
                              fieldId,
                              options[i],
                            ),
                            activeColor: defaultAccentColor_(context),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            onChanged: (_) =>
                                controller.toggleMultipleSelection(
                              fieldId,
                              options[i],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: _OptionRowLayout.checkboxTextGap),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0,left: 4),
                      child: Text(
                        options[i],
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryTextColor_(context),
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
