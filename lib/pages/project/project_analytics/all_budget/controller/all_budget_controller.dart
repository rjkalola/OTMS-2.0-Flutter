import 'dart:convert';
import 'package:belcka/pages/project/project_analytics/all_budget/controller/all_budget_repository.dart';
import 'package:belcka/pages/project/project_analytics/all_budget/model/budget_category.dart';
import 'package:belcka/pages/project/project_analytics/analytics/model/project_analytics_model.dart';
import 'package:belcka/pages/project/project_analytics/analytics/model/project_budget_analytics_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
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
  final _api = AllBudgetRepository();

  final Rxn<ProjectBudgetAnalyticsResponse> budgetAnalytics =
  Rxn<ProjectBudgetAnalyticsResponse>();
  final RxList<BudgetItem> budgets = <BudgetItem>[].obs;
  RxInt activeProjectId = 0.obs;

  final RxList<BudgetCategory> categories = <BudgetCategory>[].obs;

  late AnimationController ctrl;
  late List<Animation<double>> anims;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      activeProjectId = arguments[AppConstants.intentKey.projectId] ?? 0;
      getProjectAnalyticsBudgetApi();
    }
  }
  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void getProjectAnalyticsBudgetApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["project_id"] = activeProjectId.value;
    _api.getProjectAnalyticsBudget(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          budgetAnalytics.value = ProjectBudgetAnalyticsResponse.fromJson(jsonDecode(responseModel.result!));
          final info = budgetAnalytics.value?.info;
          budgets.clear();

          if (info != null){
            categories.assignAll([
              BudgetCategory(
                name: 'Labor',
                total: info.budgets.labor.budget,
                spent: info.budgets.labor.spent,
                color: const Color(0xFF22C55E),
                type: 'labor',
              ),
              BudgetCategory(
                name: 'Materials',
                total: info.budgets.materials.budget,
                spent: info.budgets.materials.spent,
                color: const Color(0xFFEF4444),
                type: 'materials',
              ),
              BudgetCategory(
                name: 'Others',
                total: info.budgets.others.budget,
                spent: info.budgets.others.spent,
                color: const Color(0xFF3B82F6),
                type: 'others',
              ),
            ]);
            categories.refresh();
            ctrl.reset();
            ctrl.forward();
          }
          isMainViewVisible.value = true;
          isLoading.value = false;
        }
        else{
          isLoading.value = false;
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }

      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
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
