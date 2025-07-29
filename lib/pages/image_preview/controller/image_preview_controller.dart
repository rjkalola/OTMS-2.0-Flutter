import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/file_info.dart';
import 'package:otm_inventory/pages/image_preview/controller/image_preview_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';

class ImagePreviewController extends GetxController {
  final _api = ImagePreviewRepository();

  // var itemList = <SupplierInfo>[].obs;
  var filesList = <FilesInfo>[].obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  final List<String> imagesList = [
    'https://picsum.photos/id/1015/600/400',
    'https://picsum.photos/id/1016/600/400',
    'https://picsum.photos/id/1018/600/400',
    'https://picsum.photos/id/1020/600/400',
    'https://picsum.photos/id/1024/600/400',
  ];

  final currentIndex = 0.obs;
  final pageController = PageController().obs;

  @override
  void onInit() {
    super.onInit();

    var arguments = Get.arguments;
    if (arguments != null) {
      currentIndex.value = arguments[AppConstants.intentKey.index];
      filesList.value = arguments[AppConstants.intentKey.itemList];
      pageController.value = PageController(initialPage: currentIndex.value);
      // for (int i = 0; i < imagesList.length; i++) {
      //   FilesInfo info = FilesInfo();
      //   info.file = imagesList[i];
      //   info.fileThumb = imagesList[i];
      //   filesList.add(info);
      // }
    }
  }

  void onThumbnailTap(int index) {
    pageController.value.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
