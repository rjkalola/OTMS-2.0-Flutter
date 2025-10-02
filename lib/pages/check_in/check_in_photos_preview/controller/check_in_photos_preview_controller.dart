import 'dart:convert';

import 'package:belcka/pages/check_in/check_in_photos_preview/controller/check_in_photos_preview_repository.dart';
import 'package:belcka/pages/check_in/check_in_photos_preview/model/add_checklog_attachment_response.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CheckInPhotosPreviewController extends GetxController
    implements SelectAttachmentListener, DialogButtonClickListener {
  final _api = CheckInPhotosPreviewRepository();

  // var itemList = <SupplierInfo>[].obs;
  var filesList = <FilesInfo>[].obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final List<String> imagesList = [
    'https://picsum.photos/id/1015/600/400',
    'https://picsum.photos/id/1016/600/400',
    'https://picsum.photos/id/1018/600/400',
    'https://picsum.photos/id/1020/600/400',
    'https://picsum.photos/id/1024/600/400',
  ];
  final title = "".obs;
  final currentIndex = 0.obs;
  final pageController = PageController().obs;
  int checkLogId = 0, companyTaskId = 0;
  bool isEditable = false;
  String photosType = "";

  @override
  void onInit() {
    super.onInit();

    var arguments = Get.arguments;
    if (arguments != null) {
      currentIndex.value = arguments[AppConstants.intentKey.index];
      filesList.value = arguments[AppConstants.intentKey.itemList];
      pageController.value = PageController(initialPage: currentIndex.value);
      isEditable = arguments[AppConstants.intentKey.isEditable] ?? false;
      photosType = arguments[AppConstants.intentKey.photosType] ?? "";
      checkLogId = arguments[AppConstants.intentKey.checkLogId] ?? 0;
      companyTaskId = arguments[AppConstants.intentKey.companyTaskId] ?? 0;
      title.value = photosType == AppConstants.type.beforePhotos
          ? 'photos_before'.tr
          : 'photos_after'.tr;
      // for (int i = 0; i < imagesList.length; i++) {
      //   FilesInfo info = FilesInfo();
      //   info.file = imagesList[i];
      //   info.fileThumb = imagesList[i];
      //   filesList.add(info);
      // }
    }
  }

  void addCheckLogAttachments(List<FilesInfo> list) async {
    isLoading.value = true;

    Map<String, dynamic> map = {};
    map["checklog_id"] = checkLogId;
    map["company_task_id"] = companyTaskId;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());

    for (var photo in list) {
      String key =
          "${photosType == AppConstants.type.beforePhotos ? "before_company_task_attachments" : "after_company_task_attachments"}[$companyTaskId]";
      print("$key:${photo.imageUrl!}");
      formData.files.add(
        MapEntry(
          "$key:${photo.imageUrl!}",
          await multi.MultipartFile.fromFile(
            photo.imageUrl ?? "",
          ),
        ),
      );
    }
    print("------------------------------------------------");

    _api.addCheckLogAttachments(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          AddCheckLogAttachmentResponse response =
              AddCheckLogAttachmentResponse.fromJson(
                  jsonDecode(responseModel.result!));
          print(
              "Before Photos:" + response.beforeAttachments!.length.toString());
          print("After Photos:" + response.afterAttachments!.length.toString());
          AppUtils.showApiResponseMessage(response.message ?? "");
          filesList.clear();
          if (photosType == AppConstants.type.beforePhotos) {
            filesList.addAll(response.beforeAttachments!);
          } else {
            filesList.addAll(response.afterAttachments!);
          }
          filesList.refresh();
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

  void removeCheckLogAttachmentsApi() async {
    Map<String, dynamic> map = {};
    map["attachment_id"] = filesList[currentIndex.value].id ?? 0;
    // multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());

    isLoading.value = true;
    _api.removeCheckLogAttachment(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          filesList.removeAt(currentIndex.value);
          filesList.refresh();
          if (filesList.isNotEmpty) {
            currentIndex.value = currentIndex.value - 1;
            onThumbnailTap(currentIndex.value);
          }
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

  showRemoveAttachmentDialog() async {
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
      Get.back();
      removeCheckLogAttachmentsApi();
    }
  }

  showAttachmentOptionsDialog() async {
    print("pickImage");
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'camera'.tr;
    info.action = AppConstants.attachmentType.camera;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'gallery'.tr;
    info.action = AppConstants.attachmentType.multiImage;
    listOptions.add(info);

    ManageAttachmentController().showAttachmentOptionsDialog(
        'select_photo_from_'.tr, listOptions, this);
  }

  @override
  void onSelectAttachment(List<String> paths, String action) {
    if (action == AppConstants.attachmentType.camera) {
      if (!StringHelper.isEmptyString(paths[0])) {
        List<FilesInfo> list = [];
        FilesInfo info = FilesInfo();
        info.imageUrl = paths[0];
        list.add(info);
        addCheckLogAttachments(list);
      }
    } else if (action == AppConstants.attachmentType.multiImage) {
      List<FilesInfo> list = [];
      for (var path in paths) {
        if (!StringHelper.isEmptyString(path)) {
          FilesInfo info = FilesInfo();
          info.imageUrl = path;
          list.add(info);
        }
      }
      addCheckLogAttachments(list);
    }
  }

  void onThumbnailTap(int index) {
    // pageController.value.jumpToPage(index);
    if (pageController.value.hasClients) {
      pageController.value.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Fallback if not yet attached
      currentIndex.value = index;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.value.hasClients) {
          pageController.value.jumpToPage(index);
        }
      });
    }
  }

  void onBackPress() {
    var arguments = {
      AppConstants.intentKey.photosList: filesList,
      AppConstants.intentKey.photosType: photosType,
    };
    Get.back(result: arguments);
  }
}
