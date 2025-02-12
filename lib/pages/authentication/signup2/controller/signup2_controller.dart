import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/signup2/controller/signup2_repository.dart';
import 'package:otm_inventory/pages/manageattachment/controller/manage_attachment_controller.dart';
import 'package:otm_inventory/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class SignUp2Controller extends GetxController
    implements SelectAttachmentListener {
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final imagePath = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  void showSnackBar(String message) {
    AppUtils.showSnackBarMessage(message);
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
    info.action = AppConstants.attachmentType.image;
    listOptions.add(info);

    ManageAttachmentController().showAttachmentOptionsDialog(
        'select_photo_from_'.tr, listOptions, this);
  }

  @override
  void onSelectAttachment(String path, String action) {
    if (action == AppConstants.attachmentType.camera ||
        action == AppConstants.attachmentType.image) {
      ManageAttachmentController().cropImage(path, this);
    } else if (action == AppConstants.attachmentType.croppedImage) {
      print("cropped path:" + path);
      print("action:" + action);
      imagePath.value = path;
    }
  }
}
