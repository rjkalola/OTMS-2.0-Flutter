import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';

class CertificateDetailRow extends StatelessWidget {
  const CertificateDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (StringHelper.isEmptyString(value)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: PrimaryTextView(
              text: label,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: secondaryExtraLightTextColor_(context),
            ),
          ),
          Expanded(
            flex: 3,
            child: PrimaryTextView(
              text: value ?? "",
              fontSize: 15,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
