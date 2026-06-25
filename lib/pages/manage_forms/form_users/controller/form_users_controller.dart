import 'dart:convert';

import 'package:belcka/pages/manage_forms/form_details/model/form_entry_model.dart';
import 'package:belcka/pages/manage_forms/form_users/controller/form_users_repository.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_detail_response.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/publish_target_model.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormUsersController extends GetxController {
  final _api = FormUsersRepository();

  final formEntries = <FormEntryModel>[].obs;
  final screenTitle = ''.obs;
  final searchController = TextEditingController().obs;

  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;
  final isSearchEnable = false.obs;
  final selectedDateFilterIndex = (-1).obs;

  String _searchQuery = '';
  String startDate = '';
  String endDate = '';
  List<FormEntryModel> _allFormEntries = [];

  int formId = 0;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      formId = arguments[AppConstants.intentKey.ID] ?? 0;
    }
    fetchFormUsers();
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }

  void fetchFormUsers() {
    if (formId == 0) {
      AppUtils.showSnackBarMessage('Invalid form');
      return;
    }

    isLoading.value = true;
    isInternetNotAvailable.value = false;

    _api.getFormDetail(
      formId: formId,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          final response = FormDetailResponse.fromJson(
            jsonDecode(responseModel.result!) as Map<String, dynamic>,
          );
          if (response.isSuccess == true) {
            screenTitle.value = response.info?.name ?? '';
            _applyFormEntries(
              response.info?.formEntry,
              response.info?.publishTarget,
            );
            isMainViewVisible.value = true;
          } else {
            AppUtils.showSnackBarMessage(response.message ?? '');
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if ((error.statusMessage ?? '').isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void _applyFormEntries(
    List<dynamic>? entries,
    PublishTargetModel? publishTarget,
  ) {
    final tradeByUserId = <int, String>{};
    for (final user in publishTarget?.selectedUsers ?? const []) {
      final userId = int.tryParse(user.id ?? '');
      final trade = user.tradeName?.trim();
      if (userId != null && trade != null && trade.isNotEmpty) {
        tradeByUserId[userId] = trade;
      }
    }

    final parsed = <FormEntryModel>[];
    for (final item in entries ?? const []) {
      if (item is! Map) continue;
      final entry = FormEntryModel.fromJson(Map<String, dynamic>.from(item));
      _enrichEntryTradeName(entry, tradeByUserId);
      parsed.add(entry);
    }

    parsed.sort((a, b) {
      final aDate = DateTime.tryParse(a.createdAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = DateTime.tryParse(b.createdAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    _allFormEntries = parsed;
    _applyLocalFilters();
  }

  void searchItem(String value) {
    _searchQuery = value.trim();
    _applyLocalFilters();
  }

  void clearSearch() {
    searchController.value.clear();
    _searchQuery = '';
    isSearchEnable.value = false;
    _applyLocalFilters();
  }

  void onSelectDateFilter(
    int filterIndex,
    String filter,
    String start,
    String end,
  ) {
    selectedDateFilterIndex.value = filter == 'Reset' ? -1 : filterIndex;
    startDate = start;
    endDate = end;
    _applyLocalFilters();
  }

  void _applyLocalFilters() {
    formEntries.assignAll(
      _allFormEntries.where(
        (entry) => _matchesSearch(entry) && _matchesDateFilter(entry),
      ),
    );
  }

  bool _matchesSearch(FormEntryModel entry) {
    if (StringHelper.isEmptyString(_searchQuery)) return true;

    final normalizedQuery = _searchQuery.toLowerCase();
    final userName = entry.displayName.toLowerCase();
    final trade = entry.tradeName.toLowerCase();
    return userName.contains(normalizedQuery) ||
        trade.contains(normalizedQuery);
  }

  bool _matchesDateFilter(FormEntryModel entry) {
    if (StringHelper.isEmptyString(startDate) &&
        StringHelper.isEmptyString(endDate)) {
      return true;
    }

    final createdAt = DateTime.tryParse(entry.createdAt ?? '');
    if (createdAt == null) return false;

    final localDate = DateTime(
      createdAt.toLocal().year,
      createdAt.toLocal().month,
      createdAt.toLocal().day,
    );

    if (!StringHelper.isEmptyString(startDate)) {
      final start = DateUtil.stringToDate(startDate, DateUtil.DD_MM_YYYY_SLASH);
      if (start == null) return false;
      final startOnly = DateTime(start.year, start.month, start.day);
      if (localDate.isBefore(startOnly)) return false;
    }

    if (!StringHelper.isEmptyString(endDate)) {
      final end = DateUtil.stringToDate(endDate, DateUtil.DD_MM_YYYY_SLASH);
      if (end == null) return false;
      final endOnly = DateTime(end.year, end.month, end.day);
      if (localDate.isAfter(endOnly)) return false;
    }

    return true;
  }

  void _enrichEntryTradeName(
    FormEntryModel entry,
    Map<int, String> tradeByUserId,
  ) {
    final submittedBy = entry.submittedBy;
    if (submittedBy == null) return;
    if (!StringHelper.isEmptyString(submittedBy.tradeName)) return;

    final userId = entry.submittedById ?? submittedBy.id;
    if (userId == null) return;

    final trade = tradeByUserId[userId];
    if (trade != null) {
      submittedBy.tradeName = trade;
    }
  }

  void onUserTap(FormEntryModel entry) {
    Get.toNamed(
      AppRoutes.formDetailsScreen,
      arguments: {
        AppConstants.intentKey.ID: formId,
        AppConstants.intentKey.userId: entry.submittedById,
      },
    );
  }
}
