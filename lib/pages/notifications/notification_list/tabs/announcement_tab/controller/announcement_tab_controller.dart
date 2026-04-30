import 'dart:convert';

import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/notifications/announcement_details/controller/announcement_details_repository.dart';
import 'package:belcka/pages/notifications/create_announcement/model/announcement_info.dart';
import 'package:belcka/pages/notifications/create_announcement/model/announcement_list_response.dart';
import 'package:belcka/pages/notifications/notification_list/controller/notification_list_controller.dart';
import 'package:belcka/pages/notifications/notification_list/model/announcement_emoji_response.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/controller/announcement_tab_repository.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/custom_cache_manager.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class AnnouncementTabController extends GetxController {
  final _api = AnnouncementTabRepository();
  static const List<Map<String, String>> reactionOptions = [
    {"emoji": "😊", "code": "1f60a"},
    {"emoji": "😠", "code": "1f620"},
    {"emoji": "👍", "code": "1f44d"},
    {"emoji": "👎", "code": "1f44e"},
    {"emoji": "😢", "code": "1f622"},
  ];
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

          Get.put(NotificationListController()).announcementCount.value =
              response.unreadCount ?? 0;

          readAllAnnouncement();
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

  void announcementReadApi(String ids) async {
    Map<String, dynamic> map = {};
    map["announcement_ids"] = ids;
    map["user_id"] = UserUtils.getLoginUserId();
    // isLoading.value = true;
    AnnouncementDetailsRepository().announcementRead(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        // isLoading.value = false;
      },
      onError: (ResponseModel error) {
        // isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // AppUtils.showApiResponseMessage('no_internet'.tr);
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

  onGridItemClick(int index, String action, int parentIndex) async {
    // ImageUtils.moveToImagePreview(
    //     announcementList[parentIndex].documents!, index);
    String fileUrl =
        announcementList[parentIndex].documents![index].imageUrl ?? "";
    await ImageUtils.openAttachment(
        Get.context!, fileUrl, ImageUtils.getFileType(fileUrl));
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      getAnnouncementListApi();
    }
  }

  void readAllAnnouncement() {
    String ids = "";
    List<String> listIds = [];
    if (announcementList.isNotEmpty) {
      for (var info in announcementList) {
        if (!(info.isRead ?? false)) {
          listIds.add((info.announcementId ?? 0).toString());
        }
      }
    }
    ids = listIds.join(",");
    if (!StringHelper.isEmptyString(ids)) {
      announcementReadApi(ids);
    }
  }

  Future<void> storeAnnouncementFeed({
    required int announcementId,
    required String emoji,
    required String emojiCode,
  }) async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["emoji"] = emoji;
    map["emoji_code"] = emojiCode;
    map["id"] = announcementId;
    map["user_id"] = UserUtils.getLoginUserId();
    _api.storeFeed(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          AnnouncementEmojiResponse response =
              AnnouncementEmojiResponse.fromJson(
                  jsonDecode(responseModel.result!));

          int index = -1;
          for (int i = 0; i < announcementList.length; i++) {
            AnnouncementInfo info = announcementList[i];
            if ((info.id ?? 0) == announcementId) {
              index = i;
              break;
            }
          }

          if (index >= 0) {
            int feedIndex = -1;
            for (int j = 0; j < announcementList[index].feeds!.length; j++) {
              AnnouncementFeedInfo feed = announcementList[index].feeds![j];
              if (feed.id == (response.info?.id ?? 0)) {
                feedIndex = j;
                break;
              }
            }
            if (feedIndex >= 0) {
              announcementList[index].feeds![feedIndex] = response.info!;
            } else {
              announcementList[index].feeds!.add(response.info!);
            }
          }

          announcementList.refresh();
        }
      },
      onError: (ResponseModel error) {
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if ((error.statusMessage ?? "").isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }
}
