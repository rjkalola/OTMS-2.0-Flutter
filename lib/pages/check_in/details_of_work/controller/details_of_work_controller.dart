import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:belcka/pages/check_in/details_of_work/controller/details_of_work_repository.dart';
import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/common/select_Item_list_dialog.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/module_info.dart';

class DetailsOfWorkController extends GetxController
    implements SelectItemListener, DialogButtonClickListener {
  // final companyNameController = TextEditingController().obs;
  final RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final _api = DetailsOfWorkRepository();
  final typeOfWorkController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  var filesList = <FilesInfo>[].obs;
  var selectedImageIndex = 0;
  var photosType = "";
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // fromSignUp.value =
      //     arguments[AppConstants.intentKey.fromSignUpScreen] ?? "";
    }
    // getRegisterResources();
    FilesInfo info = FilesInfo();
    filesList.add(info);
  }

// void getRegisterResources() {
//   isLoading.value = true;
//   SignUp1Repository().getRegisterResources(
//     onSuccess: (ResponseModel responseModel) {
//       if (responseModel.statusCode == 200) {
//         // fetchLocationAndAddress();
//         LocationServiceNew().checkLocationService();
//         setRegisterResourcesResponse(RegisterResourcesResponse.fromJson(
//             jsonDecode(responseModel.result!)));
//         list.addAll(registerResourcesResponse.value.currency ?? []);
//         if (mExtensionId.value != 0 &&
//             !StringHelper.isEmptyList(
//                 registerResourcesResponse.value.countries)) {
//           for (var info in registerResourcesResponse.value.countries!) {
//             if (info.id! == mExtensionId.value) {
//               mFlag.value = info.flagImage!;
//               break;
//             }
//           }
//         }
//       } else {
//         AppUtils.showSnackBarMessage(responseModel.statusMessage!);
//       }
//       isLoading.value = false;
//     },
//     onError: (ResponseModel error) {
//       isLoading.value = false;
//       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
//         isInternetNotAvailable.value = true;
//         // Utils.showSnackBarMessage('no_internet'.tr);
//       } else if (error.statusMessage!.isNotEmpty) {
//         AppUtils.showSnackBarMessage(error.statusMessage!);
//       }
//     },
//   );
// }

  onGridItemClick(int index, String action, String photoType) {
    if (action == AppConstants.action.viewPhoto) {
      if (index == 0) {
        showAttachmentOptionsDialog();
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
      info.imageUrl = path;
      filesList.add(info);
      print(filesList.length.toString());
    }
  }

  removePhotoFromList(int index) {
    if (filesList[index].id != null && filesList[index].id! > 0) {
      selectedImageIndex = index;
      AlertDialogHelper.showAlertDialog(
          "",
          'delete_item_msg'.tr,
          'yes'.tr,
          'no'.tr,
          "",
          true,
          false,
          this,
          AppConstants.dialogIdentifier.deleteProductImage);
    } else {
      filesList.removeAt(index);
    }
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.selectImageFromCamera ||
        action == AppConstants.action.selectImageFromGallery) {
      selectPhotoFrom(action);
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
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteProductImage) {
      // filesList.removeAt(selectedImageIndex);
      Get.back();
      // deleteProductImage(filesList[selectedImageIndex].id!.toString());
    }
  }
}
