import 'dart:convert';

import 'package:belcka/pages/check_in/check_in_photos_preview/controller/check_in_photos_preview_controller.dart';
import 'package:belcka/pages/check_in/check_in_photos_preview/controller/check_in_photos_preview_repository.dart';
import 'package:belcka/pages/check_in/check_in_photos_preview/model/add_checklog_attachment_response.dart';
import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;

class UserTaskDetailsController extends GetxController
    implements SelectAttachmentListener, DialogButtonClickListener {
  final _api = CheckInPhotosPreviewRepository();
  final RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  var beforePhotosList = <FilesInfo>[].obs;
  var afterPhotosList = <FilesInfo>[].obs;
  var selectedImageIndex = 0, checkLogId = 0;
  var photosType = "";
  String? checkInNote, checkOutNote;

  // final title = "".obs;
  final RxBool isEditable = false.obs,
      isBeforeEnable = false.obs,
      isAfterEnable = false.obs;
  var removeIds = <String>[];
  final info = TypeOfWorkResourcesInfo().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;

    if (arguments != null) {
      info.value = arguments[AppConstants.intentKey.typeOfWorkInfo] ??
          TypeOfWorkResourcesInfo();
      // photosType = arguments[AppConstants.intentKey.photosType] ?? "";
      // title.value = photosType == AppConstants.type.beforePhotos
      //     ? 'photos_before'.tr
      //     : 'photos_after'.tr;
      isEditable.value = arguments[AppConstants.intentKey.isEditable] ?? false;
      checkLogId = arguments[AppConstants.intentKey.checkLogId] ?? 0;
      checkInNote = arguments[AppConstants.intentKey.checkInNote] ?? "";
      checkOutNote = arguments[AppConstants.intentKey.checkOutNote] ?? "";
      // if (isEditable.value) {
      //   FilesInfo info = FilesInfo();
      //   beforePhotosList.add(info);
      //   afterPhotosList.add(info);
      // }
      // if (arguments.containsKey(AppConstants.intentKey.beforePhotosList)) {
      //   beforePhotosList
      //       .addAll(arguments[AppConstants.intentKey.beforePhotosList] ?? []);
      //   isBeforeEnable.value = true;
      // }
      //
      // if (arguments.containsKey(AppConstants.intentKey.afterPhotosList)) {
      //   afterPhotosList
      //       .addAll(arguments[AppConstants.intentKey.afterPhotosList] ?? []);
      //   isAfterEnable.value = true;
      // }

      if (arguments.containsKey(AppConstants.intentKey.beforePhotosList)) {
        beforePhotosList
            .addAll(arguments[AppConstants.intentKey.beforePhotosList] ?? []);
        isBeforeEnable.value = true;
      }

      if (arguments.containsKey(AppConstants.intentKey.afterPhotosList)) {
        afterPhotosList
            .addAll(arguments[AppConstants.intentKey.afterPhotosList] ?? []);
        isAfterEnable.value = true;
      }

      // removeIds.addAll(arguments[AppConstants.intentKey.removeIdsList] ?? []);
    }
    // getRegisterResources();
  }

  onGridItemClick(int index, String action, String photoType) {
    this.photosType = photoType;
    if (photosType == AppConstants.type.beforePhotos) {
      moveToImagePreview(beforePhotosList, index, photoType);
    } else if (photosType == AppConstants.type.afterPhotos) {
      moveToImagePreview(afterPhotosList, index, photoType);
    }
  }

  void onAddPhotoTap(String photoType) {
    if (!isEditable.value) return;
    photosType = photoType;
    showAttachmentOptionsDialog();
  }

  Future<void> moveToImagePreview(
      List<FilesInfo> filesList, int index, String photosType) async {
    this.photosType = photosType;

    if (Get.isRegistered<CheckInPhotosPreviewController>()) {
      await Get.delete<CheckInPhotosPreviewController>();
    }

    final arguments = {
      AppConstants.intentKey.itemList: filesList,
      AppConstants.intentKey.index: index,
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.isEditable: isEditable.value,
      AppConstants.intentKey.checkLogId: checkLogId,
      AppConstants.intentKey.companyTaskId: info.value.companyTaskId,
    };

    final result = await Get.toNamed(
      AppRoutes.checkInPhotosPreviewScreen,
      arguments: arguments,
    );
    _applyPhotosPreviewResult(result);
  }

  void _applyPhotosPreviewResult(dynamic result) {
    if (result == null) return;

    final resultPhotosType = result[AppConstants.intentKey.photosType];
    final list = <FilesInfo>[];
    list.addAll(result[AppConstants.intentKey.photosList] ?? []);

    if (resultPhotosType == AppConstants.type.beforePhotos) {
      beforePhotosList
        ..clear()
        ..addAll(list)
        ..refresh();
    } else if (resultPhotosType == AppConstants.type.afterPhotos) {
      afterPhotosList
        ..clear()
        ..addAll(list)
        ..refresh();
    }
  }

  void addCheckLogAttachments(List<FilesInfo> list) async {
    if (list.isEmpty) return;

    isLoading.value = true;

    final companyTaskId = info.value.companyTaskId ?? 0;
    final map = <String, dynamic>{
      'checklog_id': checkLogId,
      'company_task_id': companyTaskId,
    };
    final formData = multi.FormData.fromMap(map);

    for (final photo in list) {
      final key = photosType == AppConstants.type.beforePhotos
          ? 'before_company_task_attachments[$companyTaskId]'
          : 'after_company_task_attachments[$companyTaskId]';
      formData.files.add(
        MapEntry(
          '$key:${photo.imageUrl!}',
          await multi.MultipartFile.fromFile(photo.imageUrl ?? ''),
        ),
      );
    }

    _api.addCheckLogAttachments(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          final response = AddCheckLogAttachmentResponse.fromJson(
            jsonDecode(responseModel.result!),
          );
          AppUtils.showApiResponseMessage(response.message ?? '');
          if (photosType == AppConstants.type.beforePhotos) {
            beforePhotosList
              ..clear()
              ..addAll(response.beforeAttachments ?? [])
              ..refresh();
          } else if (photosType == AppConstants.type.afterPhotos) {
            afterPhotosList
              ..clear()
              ..addAll(response.afterAttachments ?? [])
              ..refresh();
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? '');
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

  int get progressPercent =>
      (info.value.progress ?? 0) != 0 ? (info.value.progress ?? 0) : 100;

  double get progressValue => progressPercent / 100;

  showAttachmentOptionsDialog() async {
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
    final list = <FilesInfo>[];
    if (action == AppConstants.attachmentType.camera) {
      if (!StringHelper.isEmptyString(paths[0])) {
        final info = FilesInfo();
        info.imageUrl = paths[0];
        list.add(info);
      }
    } else if (action == AppConstants.attachmentType.multiImage) {
      for (final path in paths) {
        if (!StringHelper.isEmptyString(path)) {
          final info = FilesInfo();
          info.imageUrl = path;
          list.add(info);
        }
      }
    }
    addCheckLogAttachments(list);
  }

  removePhotoFromList({required int index}) {
    if (photosType == AppConstants.type.beforePhotos) {
      beforePhotosList.removeAt(index);
    } else if (photosType == AppConstants.type.afterPhotos) {
      afterPhotosList.removeAt(index);
    }

    /*if (beforePhotosList[index].id != null && beforePhotosList[index].id! > 0) {
      selectedImageIndex = index;
      AlertDialogHelper.showAlertDialog(
          "",
          'delete_item_msg'.tr,
          'yes'.tr,
          'no'.tr,
          "",
          true,
          this,
          AppConstants.dialogIdentifier.deleteProductImage);
    } else {
      beforePhotosList.removeAt(index);
    }*/
  }

  onSubmitClick() {
    beforePhotosList.removeAt(0);
    afterPhotosList.removeAt(0);
    var arguments = {
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.beforePhotosList: beforePhotosList,
      AppConstants.intentKey.afterPhotosList: afterPhotosList,
      AppConstants.intentKey.removeIdsList: removeIds,
    };
    Get.back(result: arguments);
  }

  showNoteDialog(String title, String? note) async {
    if (!StringHelper.isEmptyString(note)) {
      AlertDialogHelper.showAlertDialog("$title:", note ?? "", 'ok'.tr.toUpperCase(), ''.tr, "",
          true, false, this, AppConstants.dialogIdentifier.noteDialog);
    }
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.noteDialog) {
      Get.back();
    }
  }

  void onBackPress() {
    info.value.beforeAttachments = beforePhotosList;
    info.value.afterAttachments = afterPhotosList;
    var arguments = {
      AppConstants.intentKey.typeOfWorkInfo: info.value,
    };
    Get.back(result: arguments);
  }
}
