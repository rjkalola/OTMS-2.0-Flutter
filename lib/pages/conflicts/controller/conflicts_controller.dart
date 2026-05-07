import 'dart:convert';

import 'package:belcka/pages/conflicts/controller/conflicts_repository.dart';
import 'package:belcka/pages/conflicts/model/conflicts_response.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConflictsController extends GetxController {
  final _api = ConflictsRepository();

  final searchController = TextEditingController().obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs;

  RxString selectedTab = ConflictsTab.all.value.obs;
  RxInt selectedDateFilterIndex = 1.obs;

  String startDate = "";
  String endDate = "";

  RxInt totalConflicts = 0.obs;

  final timesheetConflicts = <UserConflictData>[].obs;
  final billingConflicts = <UserConflictData>[].obs;
  final teamConflicts = <TeamConflictData>[].obs;
  final healthSafetyConflicts = <HealthSafetyConflictData>[].obs;
  final storeConflicts = <StoreConflictData>[].obs;
  final allCount = 0.obs;
  final timesheetCount = 0.obs;
  final billingCount = 0.obs;
  final teamCount = 0.obs;
  final healthSafetyCount = 0.obs;
  final storeCount = 0.obs;

  List<UserConflictData> _timesheetSource = [];
  List<UserConflictData> _billingSource = [];
  List<TeamConflictData> _teamSource = [];
  List<HealthSafetyConflictData> _healthSafetySource = [];
  List<StoreConflictData> _storeSource = [];

  @override
  void onInit() {
    super.onInit();
    loadData(true);
  }

  void loadData(bool isProgress) {
    isLoading.value = isProgress;
    final map = <String, dynamic>{};
    map["company_id"] = ApiConstants.companyId;
    map["start_date"] = startDate;
    map["end_date"] = endDate;

    _api.getConflicts(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response =
              ConflictsResponse.fromJson(jsonDecode(responseModel.result!));
          final info = response.info;
          totalConflicts.value = info?.totalConflicts ?? 0;

          _timesheetSource = List<UserConflictData>.from(
            info?.timesheetConflicts?.data ?? [],
          );
          _billingSource = List<UserConflictData>.from(
            info?.billingConflicts?.data ?? [],
          );
          _teamSource = List<TeamConflictData>.from(info?.teamConflicts?.data ?? []);
          _healthSafetySource = List<HealthSafetyConflictData>.from(
            info?.healthSafetyConflicts?.data ?? [],
          );

          final amount = info?.storeConflicts?.amountConflicts?.data ?? [];
          final qty = info?.storeConflicts?.qtyConflicts?.data ?? [];
          _storeSource = [...amount, ...qty];

          applySearch(searchController.value.text);
          isMainViewVisible.value = true;
        } else {
          Get.snackbar("Error", responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (!StringHelper.isEmptyString(error.statusMessage)) {
          Get.snackbar("Error", error.statusMessage ?? "");
        }
      },
    );
  }

  void onTabChange(String tab) {
    selectedTab.value = tab;
  }

  void applySearch(String value) {
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      timesheetConflicts.value = List<UserConflictData>.from(_timesheetSource);
      billingConflicts.value = List<UserConflictData>.from(_billingSource);
      teamConflicts.value = List<TeamConflictData>.from(_teamSource);
      healthSafetyConflicts.value =
          List<HealthSafetyConflictData>.from(_healthSafetySource);
      storeConflicts.value = List<StoreConflictData>.from(_storeSource);
      _refreshCounts();
      return;
    }

    timesheetConflicts.value = _timesheetSource
        .where((e) =>
            _contains(e.userName, query) ||
            _contains(e.formattedDate, query) ||
            (e.items ?? []).any((item) =>
                _contains(item.start, query) ||
                _contains(item.end, query) ||
                _contains(item.leaveName, query) ||
                _contains(item.shiftName, query)))
        .toList();

    billingConflicts.value = _billingSource
        .where((e) =>
            _contains(e.userName, query) ||
            (e.items ?? [])
                .any((item) => _contains(item.message, query) || _contains(item.conflictType, query)))
        .toList();

    teamConflicts.value = _teamSource
        .where((e) =>
            _contains(e.teamName, query) ||
            _contains(e.supervisorName, query) ||
            _contains(e.conflictType, query))
        .toList();

    healthSafetyConflicts.value = _healthSafetySource
        .where((e) =>
            _contains(e.reportedByName, query) ||
            _contains(e.hazardName, query) ||
            _contains(e.message, query) ||
            _contains(e.description, query))
        .toList();

    storeConflicts.value = _storeSource
        .where((e) =>
            _contains(e.productShortName, query) ||
            _contains(e.storeName, query) ||
            _contains(e.message, query))
        .toList();
    _refreshCounts();
  }

  bool _contains(String? value, String query) {
    return (value ?? "").toLowerCase().contains(query);
  }

  void clearSearch() {
    searchController.value.clear();
    applySearch("");
  }

  void _refreshCounts() {
    timesheetCount.value = timesheetConflicts.length;
    billingCount.value = billingConflicts.length;
    teamCount.value = teamConflicts.length;
    healthSafetyCount.value = healthSafetyConflicts.length;
    storeCount.value = storeConflicts.length;
    allCount.value = timesheetCount.value +
        billingCount.value +
        teamCount.value +
        healthSafetyCount.value +
        storeCount.value;
  }
}

enum ConflictsTab {
  all("all"),
  timesheet("timesheet"),
  billing("billing"),
  team("team"),
  healthSafety("health_safety"),
  store("store");

  const ConflictsTab(this.value);
  final String value;
}
