import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/company/company_list/controller/company_list_controller.dart';
import 'package:belcka/pages/company/switch_company/controller/switch_company_controller.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/textfield/search_text_field_dark.dart';

class SearchCompany extends StatefulWidget {
  const SearchCompany({super.key});

  @override
  State<SearchCompany> createState() => _SearchCompanyState();
}

class _SearchCompanyState extends State<SearchCompany> {
  final controller = Get.put(CompanyListController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SizedBox(
        height: 46,
        child: SearchTextFieldDark(
          controller: controller.searchController,
          isClearVisible: controller.isClearVisible,
          onValueChange: (value) {
            controller.searchItem(value.toString());
            controller.isClearVisible.value =
                !StringHelper.isEmptyString(value.toString());
          },
          onPressedClear: () {
            controller.searchController.value.clear();
            controller.searchItem("");
            controller.isClearVisible.value = false;
          },
        ),
      ),
    );
  }
}
