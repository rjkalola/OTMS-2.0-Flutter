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
  // final companyNameController = TextEditingController().obs;
  final RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  var filesList = <FilesInfo>[].obs;
  var selectedImageIndex = 0;
  var photosType = "";
  final title = "".obs;
  final RxBool isEditable = true.obs;
  final ImagePicker _picker = ImagePicker();
  var removeIds = <String>[];

  @override
  void onInit() {
    super.onInit();
    print("SelectBeforeAfterPhotosController");
    var arguments = Get.arguments;

    if (arguments != null) {
      photosType = arguments[AppConstants.intentKey.photosType] ?? "";
      title.value = photosType == AppConstants.type.beforePhotos
          ? 'photos_before'.tr
          : 'photos_after'.tr;
      isEditable.value = arguments[AppConstants.intentKey.isEditable] ?? true;
      if (isEditable.value) {
        FilesInfo info = FilesInfo();
        filesList.add(info);
      }
      filesList.addAll(arguments[AppConstants.intentKey.photosList] ?? []);
      removeIds.addAll(arguments[AppConstants.intentKey.removeIdsList] ?? []);
    }
    // getRegisterResources();
  }

  onGridItemClick(int index, String action, String photoType) {
    if (action == AppConstants.action.viewPhoto) {
      if (isEditable.value) {
        if (index == 0) {
          showAttachmentOptionsDialog();
        } else {
          ImageUtils.moveToImagePreview(
              filesList.sublist(1, filesList.length), index - 1);
        }
      } else {
        ImageUtils.moveToImagePreview(filesList, index);
      }
    } else if (action == AppConstants.action.removePhoto) {
      removePhotoFromList(index);
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

  onSubmitClick() {
    filesList.removeAt(0);
    var arguments = {
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.photosList: filesList,
      AppConstants.intentKey.removeIdsList: removeIds,
    };
    Get.back(result: arguments);
  }
}
