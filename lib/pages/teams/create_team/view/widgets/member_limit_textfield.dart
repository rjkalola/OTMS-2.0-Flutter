import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:belcka/res/colors.dart';

class MemberLimitTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onIncrementTap;
  final VoidCallback onDecrementTap;
  final double? height;

  const MemberLimitTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.onChanged,
      required this.onIncrementTap,
      required this.onDecrementTap,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??44,
      decoration: BoxDecoration(
        border: Border.all(
            color: normalTextFieldBorderDarkColor_(context), width: 0.8),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.groups_2_outlined, size: 18, color: hintColor_(context)),
          const SizedBox(width: 6),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ],
              onChanged: onChanged,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText, 
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: hintColor_(context),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              ),
            ),
          ),
          Container(
            width: 0.8,
            color: normalTextFieldBorderDarkColor_(context),
          ),
          SizedBox(
            width: 3,
          ),
          GestureDetector(
            onTap: onDecrementTap,
            child: Container(
              width: 30,
              height: double.infinity,
              alignment: Alignment.center,
              child: Icon(
                Icons.remove,
                size: 18,
                color: primaryTextColor_(context),
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrementTap,
            child: Container(
              width: 30,
              height: double.infinity,
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                size: 18,
                color: primaryTextColor_(context),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
