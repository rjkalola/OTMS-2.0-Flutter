import 'dart:convert';

import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/notifications/create_announcement/model/announcement_info.dart';
import 'package:belcka/pages/notifications/create_announcement/model/announcement_list_response.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/controller/announcement_tab_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/custom_cache_manager.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class AnnouncementTabController extends GetxController {
  final _api = AnnouncementTabRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final announcementList = <AnnouncementInfo>[].obs;
  List<AnnouncementInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments;
    // if (arguments != null) {
    //   permissionId = arguments[AppConstants.intentKey.permissionId] ?? 0;
    // }
    // getUserListApi();
    getAnnouncementListApi();
  }

  void getAnnouncementListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = ApiConstants.companyId;
    _api.getAnnouncementList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          AnnouncementListResponse response = AnnouncementListResponse.fromJson(
              jsonDecode(responseModel.result!));
          preloadUserImages(response.info ?? []);
          tempList.clear();
          tempList.addAll(response.info ?? []);
          announcementList.value = tempList;
          announcementList.refresh();
          isMainViewVisible.value = true;
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void preloadUserImages(List<AnnouncementInfo> list) {
    for (var info in list) {
      final cache = CustomCacheManager();
      cache.downloadFile(info.senderThumbImage ?? "");
    }
  }

  onGridItemClick(int index, String action,int parentIndex) {
    ImageUtils.moveToImagePreview(announcementList[parentIndex].documents!, index);
  }
}
