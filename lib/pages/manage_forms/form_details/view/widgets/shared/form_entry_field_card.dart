import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';

class FormEntryFieldCard extends StatelessWidget {
  const FormEntryFieldCard({
    super.key,
    required this.label,
    required this.child,
    this.isRequired = false,
    this.description,
    this.isNested = false,
    this.isHtmlLabel = false,
  });

  final String label;
  final Widget child;
  final bool isRequired;
  final String? description;
  final bool isNested;
  final bool isHtmlLabel;

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      borderRadius: isNested ? 12 : 16,
      margin: isNested
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldLabel(
            label: label,
            isRequired: isRequired,
            isHtml: isHtmlLabel,
          ),
          if (!StringHelper.isEmptyString(description)) ...[
            const SizedBox(height: 4),
            SubtitleTextView(
              text: description!,
              fontSize: 14,
              color: secondaryExtraLightTextColor_(context),
              maxLine: 4,
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class FormEntryTextValue extends StatelessWidget {
  const FormEntryTextValue({
    super.key,
    required this.value,
    this.topSpacing = 10,
  });

  final String? value;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    if (StringHelper.isEmptyString(value)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: topSpacing),
      child: Text(
        value!,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: primaryTextColor_(context),
          height: 1.35,
        ),
      ),
    );
  }
}
