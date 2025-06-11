import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

class SettingItemDivider extends StatelessWidget {
  const SettingItemDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 70, top: 9, right: 0),
      child: Divider(
        height: 0,
        color: dividerColor,
        thickness: 2,
      ),
    );
  }
}
