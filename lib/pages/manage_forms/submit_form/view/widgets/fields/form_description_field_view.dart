import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_description_html_content.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';

class FormDescriptionFieldView extends StatelessWidget {
  const FormDescriptionFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final content = field.label ?? '';
    if (StringHelper.isEmptyString(content)) {
      return const SizedBox.shrink();
    }

    return CardViewDashboardItem(
      borderRadius: isNested ? 12 : 16,
      margin: isNested
          ? const EdgeInsets.symmetric(horizontal: 4)
          : const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: FormDescriptionHtmlContent(html: content),
    );
  }
}
