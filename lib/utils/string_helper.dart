import 'package:flutter/cupertino.dart';

import '../web_services/response/module_info.dart';

class StringHelper {
  static bool isEmptyString(String? string) {
    bool valid = string != null && string.isNotEmpty;
    return !valid;
  }

  static bool isEmptyEdittext(String? string) {
    bool valid = string != null && string.isNotEmpty;
    return !valid;
  }

  static bool isEmptyList(List<dynamic>? list) {
    bool valid = list != null && list.isNotEmpty;
    return !valid;
  }

  static bool isEmptyObject(dynamic? info) {
    bool valid = info != null;
    return !valid;
  }

  static String getCommaSeparatedIds(List<ModuleInfo>? list) {
    String commaSeparateIds = "";
    if (list != null && list.isNotEmpty) {
      List<String> itemIds = [];
      for (int i = 0; i < list.length; i++) {
        itemIds.add(list[i].id.toString());
      }
      commaSeparateIds = itemIds.join(',');
    }
    return commaSeparateIds;
  }

  static String getCommaSeparatedStringIds(List<String>? list) {
    String commaSeparateIds = "";
    if (list != null && list.isNotEmpty) {
      List<String> itemIds = [];
      for (int i = 0; i < list.length; i++) {
        itemIds.add(list[i].toString());
      }
      commaSeparateIds = itemIds.join(',');
    }
    return commaSeparateIds;
  }

  static String getCommaSeparatedNames(List<ModuleInfo>? list) {
    String commaSeparateNames = "";
    if (list != null && list.isNotEmpty) {
      List<String> itemIds = [];
      for (int i = 0; i < list.length; i++) {
        itemIds.add(list[i].name!);
      }
      commaSeparateNames = itemIds.join(',');
    }
    return commaSeparateNames;
  }

  static List<String> getListFromCommaSeparateString(String input) {
    List<String> listString = [];
    if (!StringHelper.isEmptyString(input)) {
      listString = input.split(',');
    }
    return listString;
  }

  static String getText(TextEditingController controller) {
    String text = "";
    if (!isEmptyString(controller.text.toString().trim())) {
      text = controller.text.toString().trim();
    }
    return text;
  }

  static bool isValidBoolValue(bool? value) {
    return value != null && value;
  }

}
