import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/notifications/announcement_details/controller/announcement_details_repository.dart';
import 'package:belcka/pages/notifications/announcement_details/model/announcement_details_response.dart';
import 'package:belcka/pages/notifications/create_announcement/model/announcement_info.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AnnouncementDetailsController extends GetxController
    implements MenuItemListener, DialogButtonClickListener {
  final _api = AnnouncementDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isUpdated = false.obs;
  int announcementId = 0;
  final info = AnnouncementInfo().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      announcementId = arguments[AppConstants.intentKey.announcementId] ?? 0;
    }
    announcementDetailApi();
  }

  void announcementDetailApi() async {
    Map<String, dynamic> map = {};
    map["id"] = announcementId;
    map["user_id"] = UserUtils.getLoginUserId();
    isLoading.value = true;
    _api.announcementDetail(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          AnnouncementDetailsResponse response =
              AnnouncementDetailsResponse.fromJson(
                  jsonDecode(responseModel.result!));
          info.value = response.info!;
          // if (!(info.value.isRead ?? false)) {
          //   isUpdated.value = true;
          //   announcementReadApi();
          // }
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

  void announcementDeleteApi() async {
    Map<String, dynamic> map = {};
    map["id"] = announcementId;
    map["user_id"] = UserUtils.getLoginUserId();
    isLoading.value = true;
    _api.announcementDelete(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
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

  void announcementReadApi() async {
    Map<String, dynamic> map = {};
    map["announcement_ids"] = (info.value.announcementId ?? 0).toString();
    map["user_id"] = UserUtils.getLoginUserId();
    // isLoading.value = true;
    _api.announcementRead(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        // isLoading.value = false;
      },
      onError: (ResponseModel error) {
        // isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  onGridItemClick(int index, String action, int parentIndex) async {
    // ImageUtils.moveToImagePreview(info.value.documents!, index);
    String fileUrl =
        info.value.documents![index].imageUrl ?? "";
    await ImageUtils.openAttachment(
        Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems
        .add(ModuleInfo(name: 'delete'.tr, action: AppConstants.action.delete));

    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (info.action == AppConstants.action.delete) {
      showDeleteShiftDialog();
    }
  }

  showDeleteShiftDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_delete'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.delete);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      announcementDeleteApi();
      Get.back();
    }
  }

  void onBackPress() {
    Get.back(result: isUpdated.value);
  }
}
