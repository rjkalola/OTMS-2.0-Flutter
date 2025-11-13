import 'dart:async';
import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/dashboard/tabs/more_tab/view/more_tab.dart';
import 'package:belcka/pages/profile/my_account/controller/my_account_repository.dart';
import 'package:belcka/pages/profile/my_account/model/my_account_menu_item.dart';
import 'package:belcka/pages/profile/my_profile_details/model/my_profile_info_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dashboard/tabs/home_tab2/view/home_tab.dart';

class MyAccountController extends GetxController
    with GetSingleTickerProviderStateMixin
    implements DialogButtonClickListener {
  final _api = MyAccountRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final title = 'dashboard'.tr.obs;
  final selectedIndex = 0.obs;
  late final PageController pageController;
  final tabs = <Widget>[
    // StockListScreen(),
    HomeTab(),
    // ProfileTab(),
    MoreTab(),
    MoreTab(),
    MoreTab(),
    MoreTab(),
  ];

  List<MyAccountMenuItem> menuItems() {
    var arrayItems = <MyAccountMenuItem>[];
    arrayItems.add(MyAccountMenuItem(
        title: 'billing'.tr,
        action: AppConstants.action.billingInfo,
        iconData: Icons.receipt));
    arrayItems.add(MyAccountMenuItem(
      title: 'health_info'.tr,
      iconData: Icons.health_and_safety_outlined,
      action: AppConstants.action.healthInfo,
    ));
    arrayItems.add(MyAccountMenuItem(
        title: 'health_safety'.tr,
        action: AppConstants.action.healthSafety,
        iconData: Icons.favorite_border));
    arrayItems.add(MyAccountMenuItem(
        title: 'my_requests'.tr,
        action: AppConstants.action.myRequests,
        iconData: Icons.request_page_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'documents'.tr,
        action: AppConstants.action.documents,
        iconData: Icons.insert_drive_file_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'my_leaves'.tr,
        action: AppConstants.action.myLeaves,
        iconData: Icons.beach_access_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'digital_id'.tr,
        action: AppConstants.action.digitalId,
        iconData: Icons.badge_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'rent'.tr,
        action: AppConstants.action.rent,
        iconData: Icons.home_outlined));
    arrayItems.add(MyAccountMenuItem(
        title: 'history'.tr,
        action: AppConstants.action.history,
        iconData: Icons.history));
    if (UserUtils.isLoginUser(userId)) {
      arrayItems.add(MyAccountMenuItem(
          title: 'notification_settings'.tr,
          action: AppConstants.action.notificationSettings,
          iconData: Icons.notifications_none_outlined));
    }
    return arrayItems;
  }

  // final List<Map<String, dynamic>> menuItems = [
  //   {'icon': Icons.receipt, 'title': 'billing'.tr},
  //   {'icon': Icons.health_and_safety_outlined, 'title': 'health_info'.tr},
  //   {'icon': Icons.favorite_border, 'title': 'health_safety'.tr},
  //   {'icon': Icons.request_page_outlined, 'title': "my_requests".tr},
  //   {'icon': Icons.insert_drive_file_outlined, 'title': 'documents'.tr},
  //   {'icon': Icons.beach_access_outlined, 'title': 'my_leaves'.tr},
  //   {'icon': Icons.badge_outlined, 'title': 'digital_id'.tr},
  //   {'icon': Icons.home_outlined, 'title': 'rent'.tr},
  //   {'icon': Icons.history, 'title': 'history'.tr},
  //   {
  //     'icon': Icons.notifications_none_outlined,
  //     'title': 'notification_settings'.tr
  //   },
  // ];

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );
  int? userId = UserUtils.getLoginUserId();
  final userInfo = UserUtils.getUserInfo().obs;

  // final isOtherUserProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
    setTitle(selectedIndex.value);
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ??
          UserUtils.getLoginUserId();
    }
    if (!UserUtils.isLoginUser(userId)) {
      getProfileAPI();
    } else {
      isMainViewVisible.value = true;
    }
  }

  void setTitle(int index) {
    if (index == 0) {
      title.value = 'dashboard'.tr;
    } else if (index == 1) {
      title.value = 'more'.tr;
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
    print("selectedIndex.value:${selectedIndex.value}");
    setTitle(index);
  }

  void onItemTapped(int index) {
    // if (index == 1) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ScannerScreen()),
    //   );
    // } else {
    pageController.jumpToPage(index);

    // }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {}
  }

  void getProfileAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = userId;
    map["company_id"] = ApiConstants.companyId;
    isLoading.value = true;
    _api.getProfile(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          MyProfileInfoResponse response =
              MyProfileInfoResponse.fromJson(jsonDecode(responseModel.result!));
          userInfo.value = response.info!;
          isMainViewVisible.value = true;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }

  void removeUserPermanentlyAPI() async {
    Map<String, dynamic> map = {};
    map["user_id"] = userId;
    map["company_id"] = ApiConstants.companyId;
    isLoading.value = true;
    _api.removeUserPermanently(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }

  void archiveUserAPI() async {
    Map<String, dynamic> map = {};
    map["user_ids"] = userId.toString();
    map["company_id"] = ApiConstants.companyId;
    isLoading.value = true;
    _api.archiveUser(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }

  void showRemoveUserOptionDialog() {
    Get.defaultDialog(
      title: '',
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      backgroundColor: backgroundColor_(Get.context!),
      radius: 16,
      barrierDismissible: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          TitleTextView(
            text:
                "Delete \"${userInfo.value.firstName ?? ""} ${userInfo.value.lastName ?? ""}\"?",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          PrimaryTextView(
            text: 'remove_user_note1'.tr,
            textAlign: TextAlign.center,
            fontSize: 15,
            color: primaryTextColor_(Get.context!),
          ),
          SizedBox(
            height: 10,
          ),
          PrimaryTextView(
            text: 'remove_user_note2'.tr,
            textAlign: TextAlign.center,
            fontSize: 15,
            color: primaryTextColor_(Get.context!),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: PrimaryBorderButton(
                  height: 44,
                  fontSize: 14,
                  buttonText: 'archive'.tr,
                  fontWeight: FontWeight.w400,
                  onPressed: () {
                    Get.back();
                    archiveUserAPI();
                  },
                  fontColor: defaultAccentColor_(Get.context!),
                  borderColor: defaultAccentColor_(Get.context!),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: PrimaryButton(
                  height: 44,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  buttonText: 'delete_forever'.tr,
                  onPressed: () {
                    Get.back();
                    showRemoveUserConfirmationDialog();
                  },
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  showRemoveUserConfirmationDialog() async {
    AlertDialogHelper.showAlertDialog(
        "",
        'are_you_sure_you_want_to_remove'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        false,
        this,
        AppConstants.dialogIdentifier.delete);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.delete) {
      removeUserPermanentlyAPI();
      Get.back();
    }
  }
}
