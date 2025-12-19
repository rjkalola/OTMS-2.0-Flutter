import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/listener/select_user_listener.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/common/select_multiple_user_dialog.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_repository.dart';
import 'package:belcka/pages/permissions/user_list/model/user_list_response.dart';
import 'package:belcka/pages/teams/create_team/controller/create_team_repository.dart';
import 'package:belcka/pages/teams/team_list/model/team_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';

class CreateTeamController extends GetxController
    implements SelectUserListener, SelectItemListener {
  final teamNameController = TextEditingController().obs;
  final supervisorController = TextEditingController().obs;

  final formKey = GlobalKey<FormState>();
  final _api = CreateTeamRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs;

  final teamMembersList = <UserInfo>[].obs;
  final teamUserList = <UserInfo>[].obs;
  final userList = <UserInfo>[].obs;

  int supervisorId = 0;
  TeamInfo? teamInfo;
  final title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      teamInfo = arguments[AppConstants.intentKey.teamInfo];
    }
    teamUserListApiApi(teamInfo?.id ?? 0);
    setInitData();
  }

  void setInitData() {
    if (teamInfo != null) {
      title.value = 'Edit Team'.tr;
      teamNameController.value.text = teamInfo?.name ?? "";
      supervisorController.value.text = teamInfo?.supervisorName ?? "";
      supervisorId = teamInfo?.supervisorId ?? 0;
      teamMembersList.addAll(teamInfo?.teamMembers ?? []);
    } else {
      title.value = 'create_new_team'.tr;
      isSaveEnable.value = true;
    }
  }

  // ---------------- USER LIST ----------------

  void getUserListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
    };

    UserListRepository().getUserList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          UserListResponse response =
          UserListResponse.fromJson(jsonDecode(responseModel.result!));
          userList.value = response.info ?? [];
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode ==
            ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  // ---------------- CREATE / UPDATE ----------------

  void createTeamApi() {
    if (!valid()) return;

    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "supervisor_id": supervisorId,
      "name": StringHelper.getText(teamNameController.value),
      "team_member_ids":
      UserUtils.getCommaSeparatedIdsString(teamMembersList),
    };

    isLoading.value = true;
    _api.addTeam(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(
              responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        AppUtils.showApiResponseMessage(
            error.statusMessage ?? 'Error');
      },
    );
  }

  void updateTeamApi() {
    if (!valid()) return;

    Map<String, dynamic> map = {
      "id": teamInfo?.id ?? 0,
      "company_id": ApiConstants.companyId,
      "supervisor_id": supervisorId,
      "name": StringHelper.getText(teamNameController.value),
      "team_member_ids":
      UserUtils.getCommaSeparatedIdsString(teamMembersList),
    };

    isLoading.value = true;
    _api.updateTeam(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
          BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(
              responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        AppUtils.showApiResponseMessage(
            error.statusMessage ?? 'Error');
      },
    );
  }

  // ---------------- TEAM USER LIST ----------------

  void teamUserListApiApi(int teamId) {
    Map<String, dynamic> map = {
      "team_id": teamId,
      "company_id": ApiConstants.companyId,
    };

    isLoading.value = true;
    _api.teamUserListApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          UserListResponse response =
          UserListResponse.fromJson(jsonDecode(responseModel.result!));
          teamUserList.addAll(response.info ?? []);
          getUserListApi();
        } else {
          AppUtils.showApiResponseMessage(
              responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        AppUtils.showApiResponseMessage(
            error.statusMessage ?? 'Error');
      },
    );
  }

  bool valid() => formKey.currentState!.validate();

  // ---------------- SUPERVISOR ----------------

  void showSelectSupervisorDialog() {
    if (userList.isNotEmpty) {
      showDropDownDialog(
        AppConstants.action.selectSupervisorDialog,
        'select_supervisor'.tr,
        DataUtils.getModuleListFromUserList(userList),
        this,
      );
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
      DropDownListDialog(
        title: title,
        dialogType: dialogType,
        list: list,
        listener: listener,
        isCloseEnable: true,
        isSearchEnable: true,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  // ---------------- TEAM MEMBERS ----------------

  void showSelectTeamMemberListDialog() {
    // ❌ supervisor should not appear in team members
    List<UserInfo> filteredUsers = teamUserList
        .where((user) => user.id != supervisorId)
        .toList();

    List<UserInfo> dialogList = UserUtils.getCheckedUserList(
      getUserListCopied(filteredUsers),
      teamMembersList,
    );

    Get.bottomSheet(
      SelectMultipleUserDialog(
        title: 'select_team_members'.tr,
        dialogIdentifier:
        AppConstants.dialogIdentifier.selectTeamMembers,
        list: dialogList,
        listener: this,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  List<UserInfo> getUserListCopied(List<UserInfo> inputList) {
    return inputList
        .map((info) => UserInfo().copyUserInfo(userInfo: info))
        .toList();
  }

  @override
  void onSelectMultipleUser(
      String dialogIdentifier, List<UserInfo> listUsers) {
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.selectTeamMembers) {
      isSaveEnable.value = true;
      teamMembersList.clear();
      for (var info in listUsers) {
        if (info.isCheck == true) {
          teamMembersList.add(info);
        }
      }
      teamMembersList.refresh();
    }
  }

  @override
  void onSelectUser(String dialogIdentifier, UserInfo userInfo) {}

  // 🔥 SUPERVISOR ALWAYS WINS
  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectSupervisorDialog) {
      isSaveEnable.value = true;
      supervisorController.value.text = name;
      supervisorId = id;

      // ❌ remove supervisor from team members if exists
      teamMembersList.removeWhere((user) => user.id == supervisorId);
      teamMembersList.refresh();
    }
  }
}
