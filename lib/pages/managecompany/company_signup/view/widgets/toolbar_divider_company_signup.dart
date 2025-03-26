import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

class ToolbarDividerCompanySignup extends StatelessWidget {
  const ToolbarDividerCompanySignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 5,
      height: 5,
      color: defaultAccentColor,
    );
  }
}
