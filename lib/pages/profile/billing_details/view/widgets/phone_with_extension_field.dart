import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget PhoneWithExtensionField(String value, String label) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.blue)),
      ],
    ),
  );
}
