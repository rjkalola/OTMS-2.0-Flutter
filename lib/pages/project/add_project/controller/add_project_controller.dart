import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/project/add_project/controller/add_project_repository.dart';

class AddProjectController extends GetxController {
  final projectNameController = TextEditingController().obs;
  final shiftController = TextEditingController().obs;
  final teamController = TextEditingController().obs;
  final siteAddressController = TextEditingController().obs;
  final budgetController = TextEditingController().obs;
  final addGeofenceController = TextEditingController().obs;
  final addAddressesController = TextEditingController().obs;
  final projectCodeController = TextEditingController().obs;
  final statusController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddProjectRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSaveEnable = false.obs;
  final title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // teamInfo = arguments[AppConstants.intentKey.teamInfo];
    }
    setInitData();
  }

  void setInitData() {
    title.value = 'add_project'.tr;
    /*if (teamInfo != null) {
      title.value = 'Edit Team'.tr;
      teamNameController.value.text = teamInfo?.name ?? "";
      supervisorController.value.text = teamInfo?.supervisorName ?? "";
      supervisorId = teamInfo?.supervisorId ?? 0;
      teamMembersList.addAll(teamInfo?.teamMembers ?? []);
    } else {
      title.value = 'create_new_team'.tr;
      isSaveEnable.value = true;
    }*/
  }

/*  void getUserListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    UserListRepository().getUserList(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          UserListResponse response =
              UserListResponse.fromJson(jsonDecode(responseModel.result!));
          userList.value = response.info!;
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void createTeamApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["company_id"] = ApiConstants.companyId;
      map["supervisor_id"] = supervisorId;
      map["name"] = StringHelper.getText(teamNameController.value);
      map["team_member_ids"] =
          UserUtils.getCommaSeparatedIdsString(teamMembersList);
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
            AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
          }
          isLoading.value = false;
        },
        onError: (ResponseModel error) {
          isLoading.value = false;
          if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
            AppUtils.showApiResponseMessage('no_internet'.tr);
          } else if (error.statusMessage!.isNotEmpty) {
            AppUtils.showApiResponseMessage(error.statusMessage);
          }
        },
      );
    }
  }*/

  bool valid() {
    return formKey.currentState!.validate();
  }
}
