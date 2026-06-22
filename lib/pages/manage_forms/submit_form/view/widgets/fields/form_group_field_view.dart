import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/form_field_renderer.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';

class FormGroupFieldView extends StatelessWidget {
  const FormGroupFieldView({super.key, required this.field});

  final FormFieldModel field;

  @override
  Widget build(BuildContext context) {
    final children = field.fields ?? [];

    return CardViewDashboardItem(
      borderRadius: 16,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          if (children.isNotEmpty) const SizedBox(height: 12),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            FormFieldRenderer(
              field: children[i],
              isNested: true,
            ),
          ],
        ],
      ),
    );
  }
}
