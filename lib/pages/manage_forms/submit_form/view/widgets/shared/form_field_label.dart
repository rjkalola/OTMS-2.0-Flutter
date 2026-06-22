import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/html_textview.dart';
import 'package:flutter/material.dart';

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
    this.isHtml = false,
  });

  final String label;
  final bool isRequired;
  final bool isHtml;

  @override
  Widget build(BuildContext context) {
    if (StringHelper.isEmptyString(label)) {
      return const SizedBox.shrink();
    }

    if (isHtml) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HtmlTextView(
            text: label,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          if (isRequired)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '*',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      );
    }

    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryTextColor_(context),
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
