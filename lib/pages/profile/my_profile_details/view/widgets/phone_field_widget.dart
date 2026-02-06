import 'package:belcka/pages/profile/my_profile_details/controller/my_profile_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneFieldWidget extends StatelessWidget {
  PhoneFieldWidget({super.key});

  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: normalTextFieldBorderColor_(context),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'phone_number'.tr,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  controller.phoneController.value.text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:FontWeight.w400
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}