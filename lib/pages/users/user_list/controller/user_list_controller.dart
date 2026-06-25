import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/permissions/user_list/model/user_list_response.dart';
import 'package:belcka/pages/users/user_list/controller/user_list_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/custom_cache_manager.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserListController extends GetxController implements MenuItemListener {
  final _api = UserListRepository();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isDataUpdated = false.obs,
      isLoadingMore = false.obs;
  final searchController = TextEditingController().obs;
  final usersList = <UserInfo>[].obs;
  final totalUsers = 0.obs;
  final workingMemberCount = 0.obs;
  List<UserInfo> tempList = [];

  Timer? _debounce;
  String _searchQuery = '';

  var currentPage = 1.obs;
  int limit = 20;
  var hasMoreData = true.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getUserListApi(isRefresh: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading.value && !isLoadingMore.value && hasMoreData.value) {
          getUserListApi(showLoading: false);
        }
      }
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> getUserListApi({bool showLoading = true, bool isRefresh = false}) async{
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      tempList.clear();
      usersList.clear();
      usersList.refresh();
    }
    if (!hasMoreData.value && !isRefresh) return;

    if (currentPage.value == 1) {
      if (showLoading) isLoading.value = true;
    }
    else{
      isLoadingMore.value = true;
    }

    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["page"] = currentPage.value;
    map["limit"] = limit;
    map["search"] = _searchQuery;

    _api.getUserList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {

        isLoading.value = false;
        isLoadingMore.value = false;

        if (responseModel.isSuccess) {
          UserListResponse response =
          UserListResponse.fromJson(jsonDecode(responseModel.result!));
          ImageUtils.preloadUserImages(response.info ?? []);

          if (response.pagination != null) {
            var newItems = response.info ?? [];

            print("Total pages: ${response.pagination!.totalPages}");
            print("Current page: ${response.pagination!.currentPage}");

            tempList.addAll(newItems);
            int totalPages = response.pagination!.totalPages ?? 1;
            int apiCurrentPage = response.pagination!.currentPage ?? 1;
            if (apiCurrentPage >= totalPages) {
              hasMoreData.value = false;
            }
            else{
              hasMoreData.value = true;
              currentPage.value++;
            }
          }
          else{
            print("Pagination error: 'data' object is null or failed to parse");
          }

          usersList.value = List.from(tempList);

          usersList.refresh();
          totalUsers.value = response.totalUsers ?? 0;
          workingMemberCount.value = response.workingMemberCount ?? 0;
          isMainViewVisible.value = true;
          isLoading.value = false;
        }
        else{
          isLoading.value = false;
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isLoadingMore.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void preloadUserImages(List<UserInfo> list) {
    for (var info in list) {
      final cache = CustomCacheManager();
      cache.downloadFile(info.userThumbImage ?? "");
    }
  }

  int getDisplayWorkingMemberCount() => workingMemberCount.value;

  int getDisplayTotalUsersCount() => totalUsers.value;

  void clearSearch() {
    _debounce?.cancel();
    searchController.value.clear();
    _searchQuery = '';
    currentPage.value = 1;
    getUserListApi(isRefresh: true);
  }

  void searchItem(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = value.trim();
      currentPage.value = 1;
      getUserListApi(isRefresh: true);
    });
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      currentPage.value = 1;
      getUserListApi(isRefresh: true);
    }
  }

  Future<void> moveToUserProfile(int userId) async {
    var result = null;
    if (UserUtils.isAdmin()) {
      var arguments = {
        AppConstants.intentKey.userId: userId,
      };
      result =
          await Get.toNamed(AppRoutes.myAccountScreen, arguments: arguments);
    } else {
      var arguments = {
        AppConstants.intentKey.userId: userId,
      };
      result = await Get.toNamed(AppRoutes.myProfileDetailsScreen,
          arguments: arguments);
    }

    if (result != null && result) {
      currentPage.value = 1;
      getUserListApi(isRefresh: true);
    }
  }

  void showMenuItemsDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    listItems.add(ModuleInfo(
        name: 'invite_user'.tr, action: AppConstants.action.inviteUser));
    listItems.add(ModuleInfo(
        name: 'archived_users'.tr, action: AppConstants.action.archivedUsers));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  Future<void> onSelectMenuItem(ModuleInfo info, String dialogType) async {
    if (info.action == AppConstants.action.inviteUser) {
      moveToScreen(AppRoutes.inviteUserScreen, null);
    } else if (info.action == AppConstants.action.archivedUsers) {
      moveToScreen(AppRoutes.archiveUserListScreen, null);
    }
  }
}
