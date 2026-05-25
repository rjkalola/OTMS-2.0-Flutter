import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/store_settings/model/team_member_list_response.dart';
import 'package:belcka/pages/workshop/team_member_list/controller/team_member_list_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamMemberListController extends GetxController
    implements SelectItemListener, DateFilterListener {
  final _api = TeamMemberListRepository();

  final teams = <TeamMemberListItemInfo>[].obs;
  final selectedTeamFilterId = (-1).obs;
  final selectedTeamFilterName = ''.obs;
  final selectedDateFilterIndex = 2.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController().obs;
  final startDate = ''.obs;
  final endDate = ''.obs;
  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;
  final isSearchEnable = false.obs;
  final isClearVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedTeamFilterName.value = 'all_teams'.tr;
    final dates = DateUtil.getDateWeekRange('Month');
    startDate.value =
        DateUtil.dateToString(dates[0], DateUtil.DD_MM_YYYY_SLASH);
    endDate.value = DateUtil.dateToString(dates[1], DateUtil.DD_MM_YYYY_SLASH);
    getTeamMemberListApi();
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }

  void getTeamMemberListApi() {
    isLoading.value = true;
    final map = <String, dynamic>{
      'user_id': UserUtils.getLoginUserId(),
      'start_date': startDate.value,
      'end_date': endDate.value,
    };

    _api.getTeamMemberList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          final decoded =
              jsonDecode(responseModel.result!) as Map<String, dynamic>;
          final response = TeamMemberListResponse.fromJson(decoded);
          if (response.isSuccess == true) {
            isMainViewVisible.value = true;
            teams.assignAll(response.info ?? []);
            final ids =
                teams.map((team) => team.teamId).whereType<int>().toSet();
            if (selectedTeamFilterId.value != -1 &&
                !ids.contains(selectedTeamFilterId.value)) {
              selectedTeamFilterId.value = -1;
            }
            _syncTeamFilterLabel();
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

  List<TeamMemberUserInfo> buildDisplayUsers() {
    selectedTeamFilterId.value;
    selectedTeamFilterName.value;
    searchQuery.value;
    teams.length;

    final q = searchQuery.value.toLowerCase().trim();
    final users = <TeamMemberUserInfo>[];
    for (final team in teams) {
      if (selectedTeamFilterId.value != -1 &&
          team.teamId != selectedTeamFilterId.value) {
        continue;
      }
      for (final user in team.users ?? <TeamMemberUserInfo>[]) {
        final matchesSearch = q.isEmpty ||
            (!StringHelper.isEmptyString(user.name) &&
                user.name!.toLowerCase().contains(q));
        if (matchesSearch) {
          users.add(user);
        }
      }
    }
    return users;
  }

  void showFilterTeamBottomSheet() {
    if (teams.isEmpty) return;
    final list = <ModuleInfo>[
      ModuleInfo(id: -1, name: 'all_teams'.tr),
      ...teams
          .where((team) => team.teamId != null)
          .map((team) => ModuleInfo(id: team.teamId, name: team.name)),
    ];

    Get.bottomSheet(
      DropDownListDialog(
        title: 'filter_team'.tr,
        dialogType: AppConstants.dialogIdentifier.selectStoreSettingsTeamFilter,
        list: list,
        listener: this,
        isCloseEnable: true,
        isSearchEnable: true,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _syncTeamFilterLabel() {
    if (selectedTeamFilterId.value == -1) {
      selectedTeamFilterName.value = 'all_teams'.tr;
      return;
    }

    String? name;
    for (final team in teams) {
      if (team.teamId == selectedTeamFilterId.value) {
        name = team.name;
        break;
      }
    }
    selectedTeamFilterName.value =
        !StringHelper.isEmptyString(name) ? name! : 'all_teams'.tr;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    isClearVisible.value = !StringHelper.isEmptyString(value);
  }

  void clearSearch() {
    searchController.value.clear();
    searchQuery.value = '';
    isClearVisible.value = false;
  }

  void onBackPress() {
    if (isSearchEnable.value) {
      clearSearch();
      isSearchEnable.value = false;
      return;
    }
    Get.back();
  }

  void moveToCreateTeamScreen() {
    Get.toNamed(AppRoutes.createTeamScreen);
  }

  void moveToTeamListScreen() {
    Get.toNamed(
      AppRoutes.teamListScreen,
      arguments: {AppConstants.intentKey.isAllUserTeams: true},
    );
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDate,
      String endDate, String dialogIdentifier) {
    selectedDateFilterIndex.value = filterIndex;
    this.startDate.value = startDate;
    this.endDate.value = endDate;
    getTeamMemberListApi();
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectStoreSettingsTeamFilter) {
      selectedTeamFilterId.value = id;
      selectedTeamFilterName.value =
          id == -1 || StringHelper.isEmptyString(name) ? 'all_teams'.tr : name;
    }
  }
}
