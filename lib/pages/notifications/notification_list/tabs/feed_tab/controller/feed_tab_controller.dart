import 'dart:convert';

import 'package:belcka/pages/notifications/notification_list/model/feed_info.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/feed_tab/controller/feed_tab_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/custom_cache_manager.dart';
import 'package:belcka/utils/string_helper.dart';
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
    map["user_id"] = UserUtils.getLoginUserId();
    map["company_id"] = ApiConstants.companyId;
    // map["user_id"] = 13;
    // map["company_id"] = 5;
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

  void readFeedApi(int? id) {
    Map<String, dynamic> map = {};
    map["feed_ids"] = (id ?? 0).toString();
    _api.readFeed(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        } else if (error.statusMessage!.isNotEmpty) {
          // AppUtils.showSnackBarMessage(error.statusMessage ?? "");
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

  void notificationClick(FeedInfo? info, int index) {
    if (info != null) {
      String notificationType = (info.feedType ?? 0).toString();
      //Team
      if (notificationType ==
              AppConstants.notificationType.USER_ADDED_TO_TEAM ||
          notificationType ==
              AppConstants.notificationType.USER_REMOVED_FROM_TEAM) {
        if ((info.teamId ?? 0) != 0) {
          String rout = AppRoutes.teamDetailsScreen;
          var arguments = {
            AppConstants.intentKey.teamId: info.teamId ?? 0,
          };
          moveToScreen(rout, arguments: arguments, index: index);
        }
      } else if (notificationType ==
              AppConstants.notificationType.TIMESHEET_APPROVE ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_UNAPPROVE ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_CHANGE_HOURS ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_REQUEST_REJECT ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_REQUEST_DELETE ||
          notificationType ==
              AppConstants.notificationType.TIMESHEET_TO_BE_PAID ||
          notificationType == AppConstants.notificationType.TIMESHEET_EDIT ||
          notificationType == AppConstants.notificationType.WORKLOG_APPROVE ||
          notificationType == AppConstants.notificationType.WORKLOG_REJECT ||
          notificationType ==
              AppConstants.notificationType.TIME_CLOCK_EDIT_WORKLOG) {
        if ((info.worklogId ?? 0) != 0) {
          String rout = AppRoutes.stopShiftScreen;
          var arguments = {
            AppConstants.intentKey.workLogId: info.worklogId ?? 0,
            AppConstants.intentKey.userId: info.userId ?? 0,
          };
          moveToScreen(rout, arguments: arguments, index: index);
        }
      } else if (notificationType ==
          AppConstants.notificationType.ASSIGN_USER_TO_PROJECT) {
        if ((info.projectId ?? 0) != 0) {
          String rout = AppRoutes.projectDetailsScreen;
          var arguments = {
            AppConstants.intentKey.projectId: info.projectId ?? 0
          };
          moveToScreen(rout, arguments: arguments, index: index);
        }
      } else if (notificationType ==
          AppConstants.notificationType.JOIN_COMPANY) {
        moveToScreen(AppRoutes.userListScreen, arguments: null, index: index);
      } else if (info.requestType == 103) {
        //Billing Info
        if (notificationType ==
                AppConstants.notificationType.CREATE_BILLING_INFO ||
            (notificationType ==
                AppConstants.notificationType.UPDATE_BILLING_INFO) ||
            (notificationType == AppConstants.notificationType.ADD_REQUEST) ||
            (notificationType ==
                AppConstants.notificationType.UPDATE_REQUEST)) {
          if ((info.requestLogId ?? 0) != 0) {
            String rout = AppRoutes.billingRequestScreen;
            var arguments = {
              "request_log_id": info.requestLogId ?? 0,
            };
            moveToScreen(rout, arguments: arguments, index: index);
          }
        }
      } else if (info.requestType == 105) {
        if ((info.requestLogId ?? 0) != 0) {
          String rout = AppRoutes.ratesRequestScreen;
          var arguments = {
            "request_log_id": info.requestLogId ?? 0,
          };
          moveToScreen(rout, arguments: arguments, index: index);
        }
      }
    }
  }

  moveToScreen(String rout, {dynamic arguments, required int index}) async {
    readFeed(index);
    Get.toNamed(rout, arguments: arguments);
  }

  moveToScreenWithResult(String rout,
      {dynamic arguments, required int index}) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      getFeedListApi();
    }
  }

  void readFeed(int index) {
    readFeedApi(feedList[index].id ?? 0);
    feedList[index].isRead = true;
    feedList.refresh();
  }
}
