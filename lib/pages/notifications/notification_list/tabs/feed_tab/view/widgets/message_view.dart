import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageView extends StatelessWidget {
  MessageView({super.key, required this.userName, required this.message});

  final String userName, message;

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: "${userName}: ",
          style: TextStyle(
              fontSize: 16,
              color: primaryTextColor_(context),
              fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(
                text: message,
                style: TextStyle(
                    fontSize: 16,
                    color: primaryTextColor_(context),
                    fontWeight: FontWeight.w400)),
            // TextSpan(text: 'otm_received_note'.tr),
          ],
        ));
  }
}
