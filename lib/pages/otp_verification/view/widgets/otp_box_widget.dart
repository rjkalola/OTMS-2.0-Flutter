import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpBoxWidget extends StatelessWidget {
  TextEditingController boxController = TextEditingController();

  OtpBoxWidget({super.key, required this.boxController});

  // final verifyOtpController = Get.put(VerifyOtpController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffc6c6c6)),
          borderRadius: BorderRadius.circular(45)),
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        controller: boxController,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
        style: const TextStyle(
            fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w500),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
