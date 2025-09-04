import 'dart:convert';

import 'package:belcka/pages/notifications/notification_list/model/feed_info.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/feed_tab/controller/feed_tab_repository.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/custom_cache_manager.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

import '../../../model/feed_list_response.dart';

class FeedTabController extends GetxController {
  final _api = FeedTabRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final feedList = <FeedInfo>[].obs;
  List<FeedInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments;
    // if (arguments != null) {
    //   permissionId = arguments[AppConstants.intentKey.permissionId] ?? 0;
    // }
    getFeedListApi();
  }

  void getFeedListApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    // map["user_id"] = UserUtils.getLoginUserId();
    // map["company_id"] = ApiConstants.companyId;
    map["user_id"] = 13;
    map["company_id"] = 5;
    _api.getFeedList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          FeedListResponse response =
              FeedListResponse.fromJson(jsonDecode(responseModel.result!));
          preloadUserImages(response.info ?? []);
          tempList.clear();
          tempList.addAll(response.info ?? []);
          feedList.value = tempList;
          feedList.refresh();
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

  void preloadUserImages(List<FeedInfo> list) {
    for (var info in list) {
      final cache = CustomCacheManager();
      cache.downloadFile(info.userThumbImage ?? "");
    }
  }
}
