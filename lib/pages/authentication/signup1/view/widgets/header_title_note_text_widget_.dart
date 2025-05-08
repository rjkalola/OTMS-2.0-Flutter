import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';

class HeaderTitleNoteTextWidget extends StatelessWidget {
  const HeaderTitleNoteTextWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 18, left: 20, right: 20),
      child: Text(title,
          style: const TextStyle(
            color: primaryTextColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
