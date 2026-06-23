import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/manage_forms/forms_list/controller/forms_list_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/pages/manage_forms/forms_list/model/form_info.dart';
import 'package:belcka/pages/manage_forms/forms_list/model/forms_list_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormsListController extends GetxController {
  final _api = FormsListRepository();

  final formsList = <FormInfo>[].obs;
  final totalForms = 0.obs;
  final activeCount = 0.obs; 
  final archivedCount = 0.obs;

  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;
  final isSearchEnable = false.obs;
  bool fromStartWorkClick = false;

  final searchController = TextEditingController().obs;

  Timer? _debounce;
  String _searchQuery = '';
  bool fromNotification = false;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      fromStartWorkClick =
          arguments[AppConstants.intentKey.fromStartWorkClick] ?? false;
      fromNotification =
          arguments[AppConstants.intentKey.fromNotification] ?? false;
    }
    fetchFormsList();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.value.dispose();
    super.onClose();
  }

  void fetchFormsList() {
    isLoading.value = true;
    isInternetNotAvailable.value = false;

    final map = <String, dynamic>{};
    if (!StringHelper.isEmptyString(_searchQuery)) {
      map['search'] = _searchQuery;
    }

    _api.getFormsList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          final response = FormsListResponse.fromJson(
            jsonDecode(responseModel.result!) as Map<String, dynamic>,
          );
          if (response.isSuccess == true) {
            isMainViewVisible.value = true;
            formsList.assignAll(response.info?.data ?? []);
            totalForms.value =
                response.info?.pagination?.total ?? formsList.length;
            _applyFormCounts(response.info?.counts);
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
        } else if (!StringHelper.isEmptyString(error.statusMessage)) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void searchItem(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = value.trim();
      fetchFormsList();
    });
  }

  void clearSearch() {
    searchController.value.clear();
    _searchQuery = '';
    isSearchEnable.value = false;
    fetchFormsList();
  }

  void onFormTap(FormInfo form) async {
    final route = _resolveFormTapRoute(form);
    if (!StringHelper.isEmptyString(route)) {
      final result = await Get.toNamed(
        route,
        arguments: {AppConstants.intentKey.ID: form.id},
      );

      if (result != null && result == true) {
        if (fromStartWorkClick) {
          Get.back(result: true);
        } else {
          fetchFormsList();
        }
      }
    }
  }

  String _resolveFormTapRoute(FormInfo form) {
    final loginUserId = UserUtils.getLoginUserId();
    var rout = "";
    if (UserUtils.isAdmin()) {
      if (form.isAssignedToUser(loginUserId) &&
          !form.hasUserSubmitted(loginUserId)) {
        rout = AppRoutes.submitFormScreen;
      } else {
        rout = AppRoutes.formUsersScreen;
      }
    } else {
      if (form.isAssignedToUser(loginUserId)) {
        rout = form.hasUserSubmitted(loginUserId)
            ? AppRoutes.formDetailsScreen
            : AppRoutes.submitFormScreen;
      }
    }
    return rout;
  }

  void _applyFormCounts(FormsListCounts? counts) {
    if (counts != null) {
      activeCount.value = counts.active ?? 0;
      archivedCount.value = counts.archived ?? 0;
      return;
    }

    activeCount.value = formsList.where((form) => form.isPublished).length;
    archivedCount.value = formsList.where((form) => form.isArchived).length;
  }

  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
