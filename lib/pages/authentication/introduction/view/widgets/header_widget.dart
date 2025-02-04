import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/widgets/dropdown_widget_language.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LanguageDropdownWidget(),
          Text('need_help'.tr,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500
              ))
        ],
      ),
    );
  }
}
