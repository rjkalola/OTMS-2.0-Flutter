import 'package:belcka/pages/project/project_analytics/all_budget/model/budget_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBudgetController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isDataUpdated = false.obs;

  int? selectedIndex;

  final categories = [
    BudgetCategory(
      name: 'Labor',
      total: 150000,
      spent: 75500.42,
      color: Color(0xFF22C55E),
      type: "labor"
    ),
    BudgetCategory(
      name: 'Materials',
      total: 220500.42,
      spent: 220500.42,
      color: Color(0xFFEF4444),
        type: "materials"
    ),
    BudgetCategory(
      name: 'Others',
      total: 60000,
      spent: 50123.22,
      color: Color(0xFF3B82F6),
      type: "others"
    ),
  ];

  @override
  void onInit() {
    super.onInit();

  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      isDataUpdated.value = true;

    }
  }
  void onBackPress() {
    Get.back();
  }
}
