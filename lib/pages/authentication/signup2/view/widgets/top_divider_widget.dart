import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

class TopDividerWidget extends StatelessWidget {
  const TopDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              height: 5,
              color: defaultAccentColor_(context),
            ),
          ),
          const Flexible(
            flex: 1,
            child: Text(""),
          )
        ],
      ),
    );
  }
}
