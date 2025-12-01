import 'dart:io';
import 'dart:math';

import 'package:belcka/utils/app_utils.dart';
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
        action == AppConstants.attachmentType.camera ||
        action == AppConstants.attachmentType.video ||
        action == AppConstants.attachmentType.recordVideo ||
        action == AppConstants.attachmentType.documents ||
        action == AppConstants.attachmentType.pdf) {
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
          // imageQuality: imageQuality,
        );
        if (pickedFile != null) {
          List<String> files = [];
          File? compressed =
              await ImageUtils.compressImage(File(pickedFile.path));
          files.add(
              compressed != null ? compressed.path : pickedFile.path ?? "");
          attachmentListener!.onSelectAttachment(files, action);
        }
      } else if (action == AppConstants.attachmentType.recordVideo) {
        XFile? pickedFile = null;
        pickedFile = await _picker.pickVideo(
          source: ImageSource.camera,
          maxDuration: const Duration(seconds: 20),
          // maxWidth: maxWidth,
          // maxHeight: maxHeight,
          // imageQuality: imageQuality,
        );

        // final XFile? picked = await _picker.pickVideo(
        //   source: ImageSource.camera,
        //   maxDuration: const Duration(seconds: 30),
        // );

        if (pickedFile != null) {
          File original = File(pickedFile.path);
          File? compressed = await ImageUtils.compressVideo(original);
          List<String> files = [];
          files.add(compressed != null ? compressed.path : original.path ?? "");
          attachmentListener!.onSelectAttachment(files, action);
        }
      } else if (action == AppConstants.attachmentType.image ||
          action == AppConstants.attachmentType.multiImage) {
        if (action == AppConstants.attachmentType.image) {
          XFile? pickedFile = null;
          pickedFile = await _picker.pickImage(
            source: ImageSource.gallery,
          );
          if (pickedFile != null) {
            List<String> files = [];
            File? compressed =
                await ImageUtils.compressImage(File(pickedFile.path));
            files.add(
                compressed != null ? compressed.path : pickedFile.path ?? "");
            attachmentListener!.onSelectAttachment(files, action);
          }
        } else {
          final List<XFile>? pickedFiles = await _picker.pickMultiImage(
            limit: 10,
          );

          if (pickedFiles != null && pickedFiles.isNotEmpty) {
            List<String> files = [];
            for (var pickFile in pickedFiles) {
              print(pickFile.path);
              File? compressed =
                  await ImageUtils.compressImage(File(pickFile.path));
              files.add(compressed != null ? compressed.path : pickFile.path);
            }
            attachmentListener!.onSelectAttachment(files, action);
          }
        }

        /* if (pickedFile != null) {
          List<String> files = [];
          File? compressed =
              await ImageUtils.compressVideo(File(pickedFile.path));
          files.add(
              compressed != null ? compressed.path : pickedFile.path ?? "");
          attachmentListener!.onSelectAttachment(files, action);
        }

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
        }*/
      } else if (action == AppConstants.attachmentType.video) {
        XFile? pickedFile = null;
        pickedFile = await _picker.pickVideo(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          List<String> files = [];
          File? compressed =
              await ImageUtils.compressVideo(File(pickedFile.path));
          files.add(
              compressed != null ? compressed.path : pickedFile.path ?? "");
          attachmentListener!.onSelectAttachment(files, action);
        }
      } else if (action == AppConstants.attachmentType.documents) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ImageUtils.allAllowedExtensions,
        );
        if (result == null) return;
        final selectedFiles =
            result.paths.whereType<String>().map((path) => File(path)).toList();

        final List<String> files = [];

        for (final file in selectedFiles) {
          final ext = file.path.split('.').last.toLowerCase();

          if (ImageUtils.imageExtensions.contains(ext)) {
            final compressed = await ImageUtils.compressImage(file);
            files.add(compressed?.path ?? file.path);
          } else {
            files.add(file.path);
          }
        }

        attachmentListener!.onSelectAttachment(files, action);
      } else if (action == AppConstants.attachmentType.pdf) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ["pdf"],
        );
        if (result == null) return;
        final selectedFiles =
            result.paths.whereType<String>().map((path) => File(path)).toList();

        final List<String> files = [];

        for (final file in selectedFiles) {
          files.add(file.path);
        }

        attachmentListener!.onSelectAttachment(files, action);
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
