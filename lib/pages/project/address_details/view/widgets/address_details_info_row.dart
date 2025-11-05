import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

class AddressDetailsInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const AddressDetailsInfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start, // important for vertical alignment
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color: primaryTextColor_(
                context)),
          ),
          SizedBox(width: 8),
          Expanded( // <-- allows wrapping
            child: Text(
              value,
              maxLines: null,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: valueColor ?? primaryTextColor_(context),
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}