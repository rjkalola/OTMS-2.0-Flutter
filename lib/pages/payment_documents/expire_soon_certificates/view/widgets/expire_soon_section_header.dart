import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';

class ExpireSoonSectionHeader extends StatelessWidget {
  const ExpireSoonSectionHeader({
    super.key,
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: PrimaryTextView(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: secondaryExtraLightTextColor_(context).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: PrimaryTextView(
              text: count.toString(),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: secondaryLightTextColor_(context),
            ),
          ),
        ],
      ),
    );
  }
}
