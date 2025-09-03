import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/select_Item_list_dialog.dart';
import 'package:belcka/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/web_services/response/module_info.dart';

class ManageAttachmentController extends GetxController
    implements SelectItemListener {
  final ImagePicker _picker = ImagePicker();
  final imageQuality = 0;
  final double maxWidth = 0, maxHeight = 0;
  SelectAttachmentListener? attachmentListener;

  @override
  void onInit() {
    super.onInit();
  }

  void setListener(SelectAttachmentListener listener) {
    if (attachmentListener != null) attachmentListener = listener;
  }

  void showAttachmentOptionsDialog(
      String title, List<ModuleInfo> list, SelectAttachmentListener listener) {
    attachmentListener ??= listener;
    Get.bottomSheet(
        SelectItemListDialog(
            title: title, dialogType: "", list: list, listener: this),
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isScrollControlled: false);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.attachmentType.image ||
        action == AppConstants.attachmentType.camera) {
      selectImage(action, attachmentListener);
    } else if (action == AppConstants.attachmentType.multiImage) {
      selectImage(action, attachmentListener, multiSelection: true);
    }
  }

  void selectImage(String action, SelectAttachmentListener? listener,
      {bool? multiSelection}) async {
    attachmentListener ??= listener;
    try {
      if (action == AppConstants.attachmentType.camera) {
        XFile? pickedFile = null;
        pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          // maxWidth: maxWidth,
          // maxHeight: maxHeight,
          imageQuality: imageQuality,
        );
        if (pickedFile != null) {
          List<String> files = [];
          File? compressed =
              await ImageUtils.compressImage(File(pickedFile.path));
          files.add(
              compressed != null ? compressed.path : pickedFile.path ?? "");
          attachmentListener!.onSelectAttachment(files, action);
        }
      } else if (action == AppConstants.attachmentType.image ||
          action == AppConstants.attachmentType.multiImage) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: multiSelection ?? false,
          type: FileType.image,
        );

        if (result != null) {
          List<File> results = result.paths.map((path) => File(path!)).toList();
          List<String> files = [];
          for (var file in results) {
            // if(multiSelection??false){
            File? compressed = await ImageUtils.compressImage(file);
            files.add(compressed != null ? compressed.path : file.path);
            // }
          }
          attachmentListener!.onSelectAttachment(files, action);
        }
      }
    } catch (e) {
      print("error:" + e.toString());
    }
  }

  Future<void> cropImage(String path, SelectAttachmentListener listener) async {
    attachmentListener ??= listener;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'edit_photo'.tr,
          toolbarColor: backgroundColor_(Get.context!),
          toolbarWidgetColor: primaryTextColor_(Get.context!),
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.square,
          //   CropAspectRatioPresetCustom(),
          // ],
          lockAspectRatio: true,
          /*  aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ]*/
        ),
        IOSUiSettings(
          title: 'edit_photo'.tr,
          /* aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],*/
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    if (croppedFile != null) {
      List<String> files = [];
      files.add(croppedFile.path ?? "");
      attachmentListener!
          .onSelectAttachment(files, AppConstants.attachmentType.croppedImage);
    }
  }

  Future<void> cropCompanyLogo(
      String path, SelectAttachmentListener? listener) async {
    attachmentListener ??= listener;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      // compressFormat: ImageCompressFormat.jpg,
      // aspectRatio: CropAspectRatio(ratioX: 6, ratioY: 2.5),
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'edit_photo'.tr,
          toolbarColor: backgroundColor_(Get.context!),
          toolbarWidgetColor: primaryTextColor_(Get.context!),
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.square,
          //   CropAspectRatioPresetCustom(),
          // ],
          /* aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],*/
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'edit_photo'.tr,
          /* aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],*/
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    if (croppedFile != null) {
      List<String> files = [];
      files.add(croppedFile.path ?? "");
      attachmentListener!
          .onSelectAttachment(files, AppConstants.attachmentType.croppedImage);
    }
  }
}
