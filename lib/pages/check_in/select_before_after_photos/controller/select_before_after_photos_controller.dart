import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/check_in/details_of_work/controller/details_of_work_repository.dart';
import 'package:otm_inventory/pages/check_in/select_address/controller/select_address_repository.dart';
import 'package:otm_inventory/pages/check_in/select_before_after_photos/view/select_before_after_photos_screen.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/model/file_info.dart';
import 'package:otm_inventory/pages/common/select_Item_list_dialog.dart';
import 'package:otm_inventory/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class SelectBeforeAfterPhotosController extends GetxController
    implements SelectItemListener {
  // final companyNameController = TextEditingController().obs;
  final RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  var filesList = <FilesInfo>[].obs;
  var selectedImageIndex = 0;
  var photosType = "";
  final title = "".obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    print("SelectBeforeAfterPhotosController");
    var arguments = Get.arguments;
    FilesInfo info = FilesInfo();
    filesList.add(info);

    if (arguments != null) {
      photosType = arguments[AppConstants.intentKey.photosType] ?? "";
      title.value = photosType == AppConstants.type.beforePhotos
          ? 'photos_before'.tr
          : 'photos_after'.tr;
      filesList.addAll(arguments[AppConstants.intentKey.photosList] ?? []);
    }
    // getRegisterResources();
  }

  onGridItemClick(int index, String action, String photoType) {
    if (action == AppConstants.action.viewPhoto) {
      if (index == 0) {
        showAttachmentOptionsDialog();
        // selectPhotoFrom(AppConstants.action.selectImageFromGallery);
      } else {}
    } else if (action == AppConstants.action.removePhoto) {
      removePhotoFromList(index);
    }
  }

  showAttachmentOptionsDialog() async {
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'camera'.tr;
    info.action = AppConstants.action.selectImageFromCamera;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'gallery'.tr;
    info.action = AppConstants.action.selectImageFromGallery;
    listOptions.add(info);

    Get.bottomSheet(
        SelectItemListDialog(
            title: 'select_photo_from_'.tr,
            dialogType: AppConstants.dialogIdentifier.attachmentOptionsList,
            list: listOptions,
            listener: this),
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: false);
  }

  void selectPhotoFrom(String action) async {
    try {
      XFile? pickedFile;
      if (action == AppConstants.action.selectImageFromCamera) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 900,
          maxHeight: 900,
          imageQuality: 90,
        );
      } else if (action == AppConstants.action.selectImageFromGallery) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 900,
          maxHeight: 900,
          imageQuality: 90,
        );
      }

      if (pickedFile != null) {
        addPhotoToList(pickedFile!.path ?? "");
        print("Path:" + pickedFile.path ?? "");
      }
    } catch (e) {
      print("error:" + e.toString());
    }
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      FilesInfo info = FilesInfo();
      info.file = path;
      filesList.add(info);
      print(filesList.length.toString());
    }
  }

  removePhotoFromList(int index) {
    filesList.removeAt(index);
    /*if (filesList[index].id != null && filesList[index].id! > 0) {
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
      filesList.removeAt(index);
    }*/
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectImageFromCamera ||
        action == AppConstants.action.selectImageFromGallery) {
      selectPhotoFrom(action);
    }
  }

  onSubmitClick() {
    filesList.removeAt(0);
    var arguments = {
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.photosList: filesList,
    };
    Get.back(result: arguments);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteProductImage) {
      // filesList.removeAt(selectedImageIndex);
      Get.back();
      // deleteProductImage(filesList[selectedImageIndex].id!.toString());
    }
  }
}
