import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/project/project_analytics/all_budget/model/budget_category.dart';
import 'package:belcka/pages/project/project_analytics/analytics/model/project_analytics_model.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_repository.dart';
import 'package:belcka/pages/project/project_list/view/active_project_dialog.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBudgetController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs;

  int? selectedIndex;

  final categories = [
    BudgetCategory(
      name: 'Labor',
      total: 150000,
      spent: 75500.42,
      color: Color(0xFF22C55E),
    ),
    BudgetCategory(
      name: 'Materials',
      total: 220500.42,
      spent: 220500.42,
      color: Color(0xFFEF4444),
    ),
    BudgetCategory(
      name: 'Others',
      total: 60000,
      spent: 50123.22,
      color: Color(0xFF3B82F6),
    ),
  ];

  @override
  void onInit() {
    super.onInit();

  }
}
