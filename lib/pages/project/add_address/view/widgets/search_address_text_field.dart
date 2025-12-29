import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/textfield/search_text_field_dark.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/add_address_controller.dart';

class SearchAddressTextField extends StatelessWidget {
  SearchAddressTextField({super.key});

  final controller = Get.put(AddAddressController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      height: 48,
      child: SearchTextFieldDark(
        controller: controller.searchAddressController,
        isClearVisible: controller.isClearVisible,
        onValueChange: (value) {
          /*
          controller.searchPlaces(value.toString());
          controller.isClearVisible.value =
              !StringHelper.isEmptyString(value.toString());
          */
        },
        onPressedClear: () {
          controller.clearSearch();
        },
        label:'search_post_code'.tr,
        hint: 'search_post_code'.tr,
      ),
    );
  }
}
