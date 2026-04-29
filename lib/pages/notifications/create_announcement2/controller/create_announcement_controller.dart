import 'dart:convert';

import 'package:belcka/pages/authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';
import 'package:belcka/pages/common/drop_down_multi_selection_list_dialog.dart';
import 'package:belcka/pages/common/listener/company_resources_listener.dart';
import 'package:belcka/pages/common/listener/select_multi_item_listener.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/pages/notifications/create_announcement/controller/create_announcement_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/company_resources.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as multi;

class CreateAnnouncementController extends GetxController
    implements
        CompanyResourcesListener,
        SelectMultiItemListener,
        SelectAttachmentListener {
  final writeAnnouncementController = TextEditingController().obs;
  final usersController = TextEditingController().obs;
  final teamsController = TextEditingController().obs;
  final sendNotificationAsController = TextEditingController().obs;

  final formKey = GlobalKey<FormState>();
  final _api = CreateAnnouncementRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs,
      isCompanyUsers = true.obs;
  RxString sendNotificationAs = "company".obs;
  final usersList = <ModuleInfo>[].obs;
  final teamsList = <ModuleInfo>[].obs;
  var attachmentList = <FilesInfo>[].obs;
  var teamIds = <int>[].obs;
  var userIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    // if (arguments != null) {
    //   teamInfo = arguments[AppConstants.intentKey.teamInfo];
    // }
    FilesInfo info = FilesInfo();
    attachmentList.add(info);
    loadResources(true);
  }

  void loadResources(bool isProgress) {
    isLoading.value = isProgress;
    CompanyResources.getResourcesApi(
        flag: AppConstants.companyResourcesFlag.teamList, listener: this);
  }

  void createAnnouncementApi() async {
    Map<String, dynamic> map = {};
    map["title"] = StringHelper.getText(writeAnnouncementController.value);
    map["company_users"] = isCompanyUsers.value;
    map["team_ids[]"] = teamIds;
    map["user_ids[]"] = userIds;
    map["send_as"] = sendNotificationAs.value;
    map["company_id"] = ApiConstants.companyId;
    map["user_id"] = UserUtils.getLoginUserId();

    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());

    for (int i = 0; i < attachmentList.length; i++) {
      if (!StringHelper.isEmptyString(attachmentList[i].imageUrl ?? "")) {
        print("file:" + (attachmentList[i].imageUrl ?? ""));
        formData.files.add(
          MapEntry(
            "files",
            // or just 'images' depending on your backend
            await multi.MultipartFile.fromFile(
              attachmentList[i].imageUrl ?? "",
            ),
          ),
        );
      }
      print("------------------------------------------------");
    }

    isLoading.value = true;
    _api.createAnnouncement(
      formData: formData,
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
        }
      },
    );
  }

  @override
  void onCompanyResourcesResponse(bool isSuccess,
      CompanyResourcesResponse? response, String flag, bool isInternet) {
    if (isInternet) {
      if (isSuccess && response != null) {
        if (flag == AppConstants.companyResourcesFlag.teamList) {
          teamsList.addAll(response.info ?? []);
          CompanyResources.getResourcesApi(
              flag: AppConstants.companyResourcesFlag.userList, listener: this);
        } else if (flag == AppConstants.companyResourcesFlag.userList) {
          isLoading.value = false;
          isMainViewVisible.value = true;
          usersList.addAll(response.info ?? []);
        }
      }
    } else {
      isInternetNotAvailable.value = true;
      // AppUtils.showApiResponseMessage('no_internet'.tr);
    }
  }

  void showUserList() {
    if (usersList.isNotEmpty) {
      showMultiSelectionDropDownDialog(AppConstants.dialogIdentifier.selectUser,
          'select_users'.tr, usersList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showTeamList() {
    if (teamsList.isNotEmpty) {
      showMultiSelectionDropDownDialog(AppConstants.dialogIdentifier.selectTeam,
          'select_teams'.tr, teamsList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showMultiSelectionDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectMultiItemListener listener) {
    Get.bottomSheet(
        DropDownMultiSelectionListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectMultiItem(List<ModuleInfo> tempList, String action) {
    isSaveEnable.value = true;
    List<int> listSelectedItems = [];
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].check ?? false) {
        listSelectedItems.add(tempList[i].id ?? 0);
      }
    }
    if (action == AppConstants.dialogIdentifier.selectTeam) {
      // teamsController.value.text =
      //     StringHelper.getCommaSeparatedNames(listSelectedItems);
      teamsController.value.text =
          "${listSelectedItems.length} ${'teams'.tr} ${'selected'.tr}";
      teamIds.clear();
      teamIds.addAll(listSelectedItems);
    } else if (action == AppConstants.dialogIdentifier.selectUser) {
      // usersController.value.text =
      //     StringHelper.getCommaSeparatedNames(listSelectedItems);
      usersController.value.text =
          "${listSelectedItems.length} ${'users'.tr} ${'selected'.tr}";
      userIds.clear();
      userIds.addAll(listSelectedItems);
    }
  }

  onGridItemClick(int index, String action) async {
    if (action == AppConstants.action.viewPhoto) {
      if (index == 0) {
        showAttachmentOptionsDialog();
      } else {
        // var list = attachmentList.sublist(1, attachmentList.length);
        // ImageUtils.moveToImagePreview(list, index - 1);

        String fileUrl = attachmentList[index].imageUrl ?? "";
        await ImageUtils.openAttachment(
            Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
      }
    } else if (action == AppConstants.action.removePhoto) {
      removePhotoFromList(index: index);
    }
  }

  showAttachmentOptionsDialog() async {
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'capture_photo'.tr;
    info.action = AppConstants.attachmentType.camera;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'capture_video'.tr;
    info.action = AppConstants.attachmentType.recordVideo;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'photos'.tr;
    info.action = AppConstants.attachmentType.multiImage;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'videos'.tr;
    info.action = AppConstants.attachmentType.video;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'documents'.tr;
    info.action = AppConstants.attachmentType.documents;
    listOptions.add(info);

    ManageAttachmentController().showAttachmentOptionsDialog(
        'select_photo_from_'.tr, listOptions, this);
  }

  @override
  void onSelectAttachment(List<String> paths, String action) {
    if (action == AppConstants.attachmentType.camera ||
        action == AppConstants.attachmentType.recordVideo) {
      addPhotoToList(paths[0]);
    } else if (action == AppConstants.attachmentType.multiImage) {
      for (var path in paths) {
        addPhotoToList(path);
      }
    } else if (action == AppConstants.attachmentType.video) {
      for (var path in paths) {
        addPhotoToList(path);
      }
    } else if (action == AppConstants.attachmentType.documents) {
      for (var path in paths) {
        addPhotoToList(path);
      }
    }
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      FilesInfo info = FilesInfo();
      info.imageUrl = path;
      attachmentList.add(info);
    }
  }

  removePhotoFromList({required int index}) {
    attachmentList.removeAt(index);
  }

  bool valid() {
    return formKey.currentState!.validate();
  }
}
