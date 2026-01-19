import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/module_info.dart';

class TypeOfWorkDetailsController extends GetxController
    implements SelectAttachmentListener {
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
  final ImagePicker _picker = ImagePicker();
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
    /*if (action == AppConstants.action.viewPhoto) {
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
    }*/
  }

  Future<void> moveToImagePreview(
      List<FilesInfo> filesList, int index, String photosType) async {
    var arguments = {
      AppConstants.intentKey.itemList: filesList,
      AppConstants.intentKey.index: index,
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.isEditable: isEditable.value,
      AppConstants.intentKey.checkLogId: checkLogId,
      AppConstants.intentKey.companyTaskId: info.value.companyTaskId,
    };

    var result = await Get.toNamed(AppRoutes.checkInPhotosPreviewScreen,
        arguments: arguments);
    if (result != null) {
      var arguments = result;
      if (arguments != null) {
        String photosType = arguments[AppConstants.intentKey.photosType];
        var list = <FilesInfo>[].obs;
        list.addAll(arguments[AppConstants.intentKey.photosList] ?? []);
        if (photosType == AppConstants.type.beforePhotos) {
          beforePhotosList.clear();
          beforePhotosList.addAll(list);
        } else if (photosType == AppConstants.type.afterPhotos) {
          afterPhotosList.clear();
          afterPhotosList.addAll(list);
        }
      }
    }
  }

// showAttachmentOptionsDialog() async {
//   var listOptions = <ModuleInfo>[].obs;
//   ModuleInfo? info;
//
//   info = ModuleInfo();
//   info.name = 'camera'.tr;
//   info.action = AppConstants.action.selectImageFromCamera;
//   listOptions.add(info);
//
//   info = ModuleInfo();
//   info.name = 'gallery'.tr;
//   info.action = AppConstants.action.selectImageFromGallery;
//   listOptions.add(info);
//
//   Get.bottomSheet(
//       SelectItemListDialog(
//           title: 'select_photo_from_'.tr,
//           dialogType: AppConstants.dialogIdentifier.attachmentOptionsList,
//           list: listOptions,
//           listener: this),
//       backgroundColor: Colors.transparent,
//       enableDrag: false,
//       isDismissible: true,
//       isScrollControlled: false);
// }
//
// void selectPhotoFrom(String action) async {
//   try {
//     if (action == AppConstants.action.selectImageFromCamera) {
//       XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 900,
//         maxHeight: 900,
//         imageQuality: 90,
//       );
//       if (pickedFile != null) {
//         addPhotoToList(pickedFile!.path ?? "");
//         print("Path:" + pickedFile.path ?? "");
//       }
//     } else if (action == AppConstants.action.selectImageFromGallery) {
//       // pickedFile = await _picker.pickImage(
//       //   source: ImageSource.gallery,
//       //   maxWidth: 900,
//       //   maxHeight: 900,
//       //   imageQuality: 90,
//       // );
//
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         type: FileType.image,
//       );
//
//       if (result != null) {
//         List<File> files = result.paths.map((path) => File(path!)).toList();
//         for (var file in files) {
//           File? compressed = await ImageUtils.compressImage(file);
//           addPhotoToList(compressed != null ? compressed.path : file.path);
//         }
//       }
//     }
//   } catch (e) {
//     print("error:" + e.toString());
//   }
// }

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

  void onBackPress() {
    info.value.beforeAttachments = beforePhotosList;
    info.value.afterAttachments = afterPhotosList;
    var arguments = {
      AppConstants.intentKey.typeOfWorkInfo: info.value,
    };
    Get.back(result: arguments);
  }
}
