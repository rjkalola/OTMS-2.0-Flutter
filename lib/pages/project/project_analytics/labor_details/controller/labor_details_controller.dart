import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/project/project_analytics/all_budget/model/budget_category.dart';
import 'package:belcka/pages/project/project_analytics/analytics/model/project_analytics_model.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/model/labor_details_model.dart';
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

class LaborDetailsController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isDataUpdated = false.obs;

  final allEntries = [
    LaborEntry(name: 'Ramil Veliiev', role: 'IT Developer', amount: 600, hours: 40, avatarInitials: 'RV', avatarColor: Color(0xFF6366F1)),
    LaborEntry(name: 'Alex Veliiev', role: 'IT Developer', amount: 500, hours: 40, avatarInitials: 'AV', avatarColor: Color(0xFF0EA5E9)),
    LaborEntry(name: 'Rohan Veliiev', role: 'Project Manager', amount: 200, hours: 10, avatarInitials: 'RV', avatarColor: Color(0xFF10B981)),
    LaborEntry(name: 'Ramil Veliiev', role: 'IT Developer', amount: 500, hours: 35, avatarInitials: 'RV', avatarColor: Color(0xFF6366F1)),
    LaborEntry(name: 'Alex Veliiev', role: 'Senior Developer', amount: 1200, hours: 45, avatarInitials: 'AV', avatarColor: Color(0xFF0EA5E9)),
    LaborEntry(name: 'Sarah Connor', role: 'UX Designer', amount: 750, hours: 30, avatarInitials: 'SC', avatarColor: Color(0xFFF59E0B)),
    LaborEntry(name: 'James Wright', role: 'QA Engineer', amount: 420, hours: 28, avatarInitials: 'JW', avatarColor: Color(0xFFEF4444)),
  ];

  FilterPeriod filter = FilterPeriod.all;
  bool searchOpen = false;
  String searchQuery = '';
  final searchCtrl = TextEditingController();

  final double totalBudget = 150000;
  final double spent = 75500.42;
  final double available = 74499.58;

  List<LaborEntry> get filtered {
    var list = allEntries;
    if (searchQuery.isNotEmpty) {
      list = list
          .where((e) =>
      e.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          e.role.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  double get totalHours =>
      filtered.fold(0.0, (s, e) => s + e.hours);
  double get totalPaid =>
      filtered.fold(0.0, (s, e) => s + e.amount);

  late AnimationController ctrl;
  late Animation<double> fadeAnim;

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void dispose() {
    ctrl.dispose();
    searchCtrl.dispose();
    super.dispose();
  }
}
