import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/store_settings/controller/store_settings_repository.dart';
import 'package:belcka/pages/store_settings/model/team_member_list_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';

class DisplayTeamSlice {
  final TeamMemberListItemInfo team;
  final List<TeamMemberUserInfo> visibleUsers;

  DisplayTeamSlice({required this.team, required this.visibleUsers});
}

class StoreSettingsController extends GetxController
    implements SelectItemListener {
  final _api = StoreSettingsRepository();
  final teams = <TeamMemberListItemInfo>[].obs;
  final Map<int, bool> _initialShowStoreByUserId = {};
  final selectedTeamFilterId = (-1).obs;
  final selectedTeamFilterName = ''.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController().obs;
  final isClearVisible = false.obs;
  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;
  final isDataUpdated = false.obs;
  final isSearchEnable = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedTeamFilterName.value = 'all_teams'.tr;
    getTeamMemberListApi();
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }

  void getTeamMemberListApi() {
    isLoading.value = true;
    _api.getTeamMemberList(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          final decoded =
              jsonDecode(responseModel.result!) as Map<String, dynamic>;
          final response = TeamMemberListResponse.fromJson(decoded);
          if (response.isSuccess == true) {
            isMainViewVisible.value = true;
            teams.assignAll(response.info ?? []);
            final ids =
                teams.map((t) => t.teamId).whereType<int>().toSet();
            if (selectedTeamFilterId.value != -1 &&
                !ids.contains(selectedTeamFilterId.value)) {
              selectedTeamFilterId.value = -1;
            }
            _syncTeamFilterLabel();
            _captureInitial();
            isDataUpdated.value = false;
          } else {
            AppUtils.showSnackBarMessage(response.message ?? "");
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (!StringHelper.isEmptyString(error.statusMessage)) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void _captureInitial() {
    _initialShowStoreByUserId.clear();
    for (final team in teams) {
      for (final u in team.users ?? []) {
        if (u.id != null) {
          _initialShowStoreByUserId[u.id!] = u.isShowStore == true;
        }
      }
    }
  }

  void _recomputeDirty() {
    bool dirty = false;
    for (final team in teams) {
      for (final u in team.users ?? []) {
        final id = u.id;
        if (id == null) continue;
        final initial = _initialShowStoreByUserId[id] == true;
        final current = u.isShowStore == true;
        if (initial != current) {
          dirty = true;
          break;
        }
      }
      if (dirty) break;
    }
    isDataUpdated.value = dirty;
  }

  List<DisplayTeamSlice> buildDisplaySlices() {
    selectedTeamFilterId.value;
    selectedTeamFilterName.value;
    searchQuery.value;
    teams.length;
    final q = searchQuery.value.toLowerCase().trim();
    final List<DisplayTeamSlice> out = [];
    for (final team in teams) {
      if (selectedTeamFilterId.value != -1 &&
          team.teamId != selectedTeamFilterId.value) {
        continue;
      }
      final visible = (team.users ?? [])
          .where((u) =>
              q.isEmpty ||
              (!StringHelper.isEmptyString(u.name) &&
                  u.name!.toLowerCase().contains(q)))
          .toList();
      if (visible.isEmpty) continue;
      out.add(DisplayTeamSlice(team: team, visibleUsers: visible));
    }
    return out;
  }

  bool teamSwitchAllOn(List<TeamMemberUserInfo> visibleUsers) {
    if (visibleUsers.isEmpty) return false;
    return visibleUsers.every((u) => u.isShowStore == true);
  }

  void onTeamToggle(
      TeamMemberListItemInfo team, List<TeamMemberUserInfo> visibleUsers, bool value) {
    for (final u in team.users ?? []) {
      u.isShowStore = value;
    }
    teams.refresh();
    _recomputeDirty();
  }

  void onUserToggle(TeamMemberUserInfo user, bool value) {
    user.isShowStore = value;
    teams.refresh();
    _recomputeDirty();
  }

  void showFilterTeamBottomSheet() {
    if (teams.isEmpty) return;
    final list = <ModuleInfo>[
      ModuleInfo(id: -1, name: 'all_teams'.tr),
      ...teams
          .where((t) => t.teamId != null)
          .map((t) => ModuleInfo(id: t.teamId, name: t.name)),
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
    for (final t in teams) {
      if (t.teamId == selectedTeamFilterId.value) {
        name = t.name;
        break;
      }
    }
    selectedTeamFilterName.value =
        !StringHelper.isEmptyString(name) ? name! : 'all_teams'.tr;
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action ==
        AppConstants.dialogIdentifier.selectStoreSettingsTeamFilter) {
      selectedTeamFilterId.value = id;
      if (id == -1) {
        selectedTeamFilterName.value = 'all_teams'.tr;
      } else {
        selectedTeamFilterName.value =
            !StringHelper.isEmptyString(name) ? name : 'all_teams'.tr;
      }
    }
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

  List<Map<String, dynamic>> _buildUpdateUsersPayload() {
    final List<Map<String, dynamic>> list = [];
    for (final team in teams) {
      for (final u in team.users ?? []) {
        if (u.id != null) {
          list.add(u.toUpdateJson());
        }
      }
    }
    return list;
  }

  void changeBulkUserStoreStatusApi() {
    if (!isDataUpdated.value) return;
    isLoading.value = true;
    final map = <String, dynamic>{
      'company_id': ApiConstants.companyId,
      'users': _buildUpdateUsersPayload(),
    };
    _api.changeBulkUserStoreStatus(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.result != null) {
          try {
            final response =
                BaseResponse.fromJson(jsonDecode(responseModel.result!));
            if (response.IsSuccess == true) {
              AppUtils.showApiResponseMessage(response.Message ?? "");
              Get.back(result: true);
            } else {
              AppUtils.showSnackBarMessage(response.Message ?? "");
            }
          } catch (_) {
            AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (!StringHelper.isEmptyString(error.statusMessage)) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void onBackPress() {
    if (isSearchEnable.value) {
      clearSearch();
      isSearchEnable.value = false;
      return;
    }
    Get.back();
  }
}
