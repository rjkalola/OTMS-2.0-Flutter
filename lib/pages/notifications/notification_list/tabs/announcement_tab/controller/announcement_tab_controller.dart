import 'package:get/get.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/controller/announcement_tab_repository.dart';
import 'package:belcka/utils/custom_cache_manager.dart';

class AnnouncementTabController extends GetxController {
  final _api = AnnouncementTabRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final usersList = <UserInfo>[].obs;
  List<UserInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    // var arguments = Get.arguments;
    // if (arguments != null) {
    //   permissionId = arguments[AppConstants.intentKey.permissionId] ?? 0;
    // }
    // getUserListApi();
  }

  // void getUserListApi() {
  //   isLoading.value = true;
  //   Map<String, dynamic> map = {};
  //   map["company_id"] = ApiConstants.companyId;
  //   _api.getUserList(
  //     data: map,
  //     onSuccess: (ResponseModel responseModel) {
  //       if (responseModel.isSuccess) {
  //         UserListResponse response =
  //             UserListResponse.fromJson(jsonDecode(responseModel.result!));
  //         ImageUtils.preloadUserImages(response.info ?? []);
  //         tempList.clear();
  //         tempList.addAll(response.info ?? []);
  //         usersList.value = tempList;
  //         usersList.refresh();
  //         isMainViewVisible.value = true;
  //       } else {
  //         AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
  //       }
  //       isLoading.value = false;
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         isInternetNotAvailable.value = true;
  //         // AppUtils.showSnackBarMessage('no_internet'.tr);
  //         // Utils.showSnackBarMessage('no_internet'.tr);
  //       } else if (error.statusMessage!.isNotEmpty) {
  //         AppUtils.showSnackBarMessage(error.statusMessage ?? "");
  //       }
  //     },
  //   );
  // }

  void preloadUserImages(List<UserInfo> list) {
    for (var info in list) {
      final cache = CustomCacheManager();
      cache.downloadFile(info.userThumbImage ?? "");
    }
  }
}
