import 'dart:convert';

import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/store_settings/model/team_member_list_response.dart';
import 'package:belcka/pages/workshop/remove_member_from_workshop_team/controller/remove_member_from_workshop_team_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoveMemberFromWorkshopTeamController extends GetxController
    implements SelectItemListener {
  final _api = RemoveMemberFromWorkshopTeamRepository();

  final teams = <TeamMemberListItemInfo>[].obs;
  final selectedUserIds = <int>{}.obs;
  final selectedTeamName = ''.obs;
  final selectedTeamId = 0.obs;
  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController().obs;
  final isSearchEnable = false.obs;
  final isClearVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedTeamName.value = 'select_team'.tr;
    getInitialData();
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }

  void getInitialData() {
    getTeamDropdownApi();
  }

  void getTeamDropdownApi() {
    isLoading.value = true;
    final dates = DateUtil.getDateWeekRange('Month');
    final map = <String, dynamic>{
      'user_id': UserUtils.getLoginUserId(),
      'start_date': DateUtil.dateToString(dates[0], DateUtil.DD_MM_YYYY_SLASH),
      'end_date': DateUtil.dateToString(dates[1], DateUtil.DD_MM_YYYY_SLASH),
    };

    _api.getTeamMemberList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          final response = TeamMemberListResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          if (response.isSuccess == true) {
            teams.assignAll(response.info ?? []);
            if (selectedTeamId.value == 0 && teams.isNotEmpty) {
              selectedTeamId.value = teams.first.teamId ?? 0;
              selectedTeamName.value = teams.first.name ?? 'select_team'.tr;
            }
            selectedUserIds.clear();
            isMainViewVisible.value = true;
          } else {
            AppUtils.showSnackBarMessage(response.message ?? '');
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: _handleError,
    );
  }

  void _handleError(ResponseModel error) {
    isLoading.value = false;
    if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
      isInternetNotAvailable.value = true;
    } else if (!StringHelper.isEmptyString(error.statusMessage)) {
      AppUtils.showSnackBarMessage(error.statusMessage ?? '');
    }
  }

  void showTeamDropdown() {
    if (teams.isEmpty) return;
    final list = teams
        .where((team) => team.teamId != null)
        .map((team) => ModuleInfo(id: team.teamId, name: team.name))
        .toList();

    Get.bottomSheet(
      DropDownListDialog(
        title: 'select_team'.tr,
        dialogType: AppConstants.dialogIdentifier.selectTeam,
        list: list,
        listener: this,
        isCloseEnable: true,
        isSearchEnable: true,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  List<TeamMemberUserInfo> buildDisplayUsers() {
    selectedTeamId.value;
    searchQuery.value;
    teams.length;
    if (selectedTeamId.value == 0) {
      return <TeamMemberUserInfo>[];
    }

    final query = searchQuery.value.toLowerCase().trim();
    for (final team in teams) {
      if (team.teamId == selectedTeamId.value) {
        final users = team.users ?? <TeamMemberUserInfo>[];
        if (query.isEmpty) {
          return users;
        }
        return users.where((user) => _matchesSearch(user, query)).toList();
      }
    }
    return <TeamMemberUserInfo>[];
  }

  bool _matchesSearch(TeamMemberUserInfo user, String query) {
    return _fieldMatches(user.name, query) ||
        _fieldMatches(user.projectName, query) ||
        _fieldMatches(user.teamName, query) ||
        _fieldMatches(user.tradeName, query);
  }

  bool _fieldMatches(String? field, String query) {
    return !StringHelper.isEmptyString(field) &&
        field!.toLowerCase().contains(query);
  }

  void searchItem(String value) {
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

  int selectedUsersCount() {
    return selectedUserIds.length;
  }

  bool isUserSelected(TeamMemberUserInfo user) {
    return selectedUserIds.contains(user.id ?? 0);
  }

  void toggleUser(TeamMemberUserInfo user) {
    final userId = user.id ?? 0;
    if (userId == 0) {
      return;
    }
    if (selectedUserIds.contains(userId)) {
      selectedUserIds.remove(userId);
    } else {
      selectedUserIds.add(userId);
    }
    selectedUserIds.refresh();
  }

  void removeSelectedUsersFromTeam() {
    if (selectedTeamId.value == 0) {
      AppUtils.showToastMessage('select_team'.tr);
      return;
    }

    final selectedIds = selectedUserIds.join(',');
    if (StringHelper.isEmptyString(selectedIds)) {
      AppUtils.showToastMessage('empty_data_message'.tr);
      return;
    }

    isLoading.value = true;
    final map = <String, dynamic>{
      'team_id': '${selectedTeamId.value}',
      'user_ids': selectedIds,
    };
    _api.removeUserFromTeam(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.result != null) {
          final response = BaseResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          if (response.IsSuccess == true) {
            AppUtils.showApiResponseMessage(response.Message ?? '');
            Get.back(result: true);
          } else {
            AppUtils.showSnackBarMessage(response.Message ?? '');
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: _handleError,
    );
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectTeam) {
      selectedTeamId.value = id;
      selectedTeamName.value =
          !StringHelper.isEmptyString(name) ? name : 'select_team'.tr;
      selectedUserIds.clear();
      selectedUserIds.refresh();
    }
  }
}
