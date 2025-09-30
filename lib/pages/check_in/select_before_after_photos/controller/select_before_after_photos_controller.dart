import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/module_info.dart';

class SelectBeforeAfterPhotosController extends GetxController
    implements SelectAttachmentListener {
  final RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  var beforePhotosList = <FilesInfo>[].obs;
  var afterPhotosList = <FilesInfo>[].obs;
  var selectedImageIndex = 0;
  var photosType = "";

  // final title = "".obs;
  final RxBool isEditable = true.obs,
      isBeforeEnable = false.obs,
      isAfterEnable = false.obs;
  final ImagePicker _picker = ImagePicker();
  var removeIds = <String>[];

  @override
  void onInit() {
    super.onInit();
    print("SelectBeforeAfterPhotosController::::");
    var arguments = Get.arguments;

    if (arguments != null) {
      // photosType = arguments[AppConstants.intentKey.photosType] ?? "";
      // title.value = photosType == AppConstants.type.beforePhotos
      //     ? 'photos_before'.tr
      //     : 'photos_after'.tr;
      isEditable.value = arguments[AppConstants.intentKey.isEditable] ?? true;
      if (isEditable.value) {
        FilesInfo info = FilesInfo();
        beforePhotosList.add(info);
        afterPhotosList.add(info);
      }
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

      removeIds.addAll(arguments[AppConstants.intentKey.removeIdsList] ?? []);
    }
    // getRegisterResources();
  }

  onGridItemClick(int index, String action, String photoType) {
    this.photosType = photoType;
    if (action == AppConstants.action.viewPhoto) {
      if (isEditable.value) {
        if (index == 0) {
          showAttachmentOptionsDialog();
        } else {
          if (photosType == AppConstants.type.beforePhotos) {
            ImageUtils.moveToImagePreview(
                beforePhotosList.sublist(1, beforePhotosList.length),
                index - 1);
          } else if (photosType == AppConstants.type.afterPhotos) {
            ImageUtils.moveToImagePreview(
                afterPhotosList.sublist(1, afterPhotosList.length), index - 1);
          }
        }
      } else {
        if (photosType == AppConstants.type.beforePhotos) {
          ImageUtils.moveToImagePreview(beforePhotosList, index);
        } else if (photosType == AppConstants.type.afterPhotos) {
          ImageUtils.moveToImagePreview(afterPhotosList, index);
        }
      }
    } else if (action == AppConstants.action.removePhoto) {
      removePhotoFromList(index: index);
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
      addPhotoToList(paths[0]);
    } else if (action == AppConstants.attachmentType.multiImage) {
      for (var path in paths) {
        addPhotoToList(path);
      }
    }
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      FilesInfo info = FilesInfo();
      info.imageUrl = path;
      if (photosType == AppConstants.type.beforePhotos) {
        beforePhotosList.add(info);
        print(beforePhotosList.length.toString());
      } else if (photosType == AppConstants.type.afterPhotos) {
        afterPhotosList.add(info);
        print(afterPhotosList.length.toString());
      }
    }
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
}
