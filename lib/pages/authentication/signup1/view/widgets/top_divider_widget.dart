import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';

class TopDividerWidget extends StatelessWidget {
  const TopDividerWidget({super.key, required this.flex1, required this.flex2});

  final int flex1, flex2;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: flex1,
          child: Container(
            height: 5,
            color: defaultAccentColor,
          ),
        ),
        Flexible(
          flex: flex2,
          child: Container(
            height: 5,
            color: dividerColor,
          ),
        ),
      ],
    );
  }
}
