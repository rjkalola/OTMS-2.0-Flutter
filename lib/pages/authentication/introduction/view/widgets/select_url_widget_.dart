import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';

class SelectUrl extends StatelessWidget {
  const SelectUrl({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Live",
              style:  TextStyle(
                color: primaryTextColor_(context),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              )),
          const Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: Color(0xff000000),
          ),
        ],
      ),
    );
  }
}
