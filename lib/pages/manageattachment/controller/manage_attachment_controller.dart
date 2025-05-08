import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/select_Item_list_dialog.dart';
import 'package:otm_inventory/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class ManageAttachmentController extends GetxController
    implements SelectItemListener {
  final ImagePicker _picker = ImagePicker();
  final imageQuality = 0;
  final double maxWidth = 0, maxHeight = 0;
  final bool isResize = false;
  late final SelectAttachmentListener _attachmentListener;

  @override
  void onInit() {
    super.onInit();
  }

  void setListener(SelectAttachmentListener listener) {
    _attachmentListener = listener;
  }

  void showAttachmentOptionsDialog(
      String title, List<ModuleInfo> list, SelectAttachmentListener listener) {
    _attachmentListener = listener;
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
      selectImage(action, _attachmentListener);
    }
  }

  void selectImage(String action, SelectAttachmentListener listener) async {
    _attachmentListener = listener;
    try {
      XFile? pickedFile;
      if (action == AppConstants.attachmentType.camera) {
        if (isResize) {
          pickedFile = await _picker.pickImage(
            source: ImageSource.camera,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
          );
        } else {
          pickedFile = await _picker.pickImage(
            source: ImageSource.camera,
          );
        }
      } else if (action == AppConstants.attachmentType.image) {
        if (isResize) {
          pickedFile = await _picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
          );
        } else {
          pickedFile = await _picker.pickImage(
            source: ImageSource.gallery,
          );
        }
      }

      if (pickedFile != null) {
        _attachmentListener.onSelectAttachment(pickedFile.path ?? "", action);
        print("Path:" + pickedFile.path ?? "");
      }
    } catch (e) {
      print("error:" + e.toString());
    }
  }

  Future<void> cropImage(String path, SelectAttachmentListener listener) async {
    _attachmentListener = listener;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'edit_photo'.tr,
          toolbarColor: backgroundColor,
          toolbarWidgetColor: primaryTextColor,
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.square,
          //   CropAspectRatioPresetCustom(),
          // ],
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'edit_photo'.tr,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
      ],
    );
    if (croppedFile != null) {
      _attachmentListener.onSelectAttachment(
          croppedFile.path ?? "", AppConstants.attachmentType.croppedImage);
    }
  }

  Future<void> cropCompanyLogo(
      String path, SelectAttachmentListener listener) async {
    _attachmentListener = listener;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      compressFormat: ImageCompressFormat.png,
      aspectRatio: CropAspectRatio(ratioX: 6, ratioY: 2.5),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'edit_photo'.tr,
          toolbarColor: backgroundColor,
          toolbarWidgetColor: primaryTextColor,
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.square,
          //   CropAspectRatioPresetCustom(),
          // ],
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'edit_photo'.tr,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
      ],
    );
    if (croppedFile != null) {
      _attachmentListener.onSelectAttachment(
          croppedFile.path ?? "", AppConstants.attachmentType.croppedImage);
    }
  }
}
