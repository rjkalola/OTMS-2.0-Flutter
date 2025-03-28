import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';

class DialogTitleView extends StatelessWidget {
  const DialogTitleView({super.key, required this.title});

  final title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: titleBgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close, size: 20),
              ))
        ],
      ),
    );
  }
}
