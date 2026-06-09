import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_label.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_section.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormUnsupportedFieldView extends StatelessWidget {
  const FormUnsupportedFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    return FormFieldSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldLabel(
            label: field.label ?? '',
            isRequired: field.isRequired,
            isHtml: field.isHtmlLabel,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor_(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dividerColor_(context)),
            ),
            child: SubtitleTextView(
              text:
                  '${'unsupported_field_type'.tr}: ${field.type ?? ''}',
              fontSize: 13,
              color: secondaryExtraLightTextColor_(context),
            ),
          ),
        ],
      ),
    );
  }
}
