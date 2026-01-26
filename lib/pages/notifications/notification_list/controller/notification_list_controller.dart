import 'package:belcka/pages/notifications/notification_list/controller/notification_list_repository.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/view/announcement_tab.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/feed_tab/view/feed_tab.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';

class NotificationListController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs;
  final title = 'notifications'.tr.obs;
  final selectedIndex = 0.obs, announcementCount = 0.obs;
  bool fromNotification = false;
  final _api = NotificationListRepository();

  // final pageController = PageController();
  late final PageController pageController;
  final tabs = <Widget>[
    FeedTab(),
    AnnouncementTab(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      selectedIndex.value =
          arguments[AppConstants.intentKey.notificationTabIndex];
      fromNotification = arguments[AppConstants.intentKey.fromNotification];
    }
    pageController = PageController(initialPage: selectedIndex.value);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
    print("selectedIndex.value:${selectedIndex.value}");
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

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );

  void onActionButtonClick(String action) {
    if (action == AppConstants.action.items) {
      Get.offNamed(AppRoutes.productListScreen);
    } else if (action == AppConstants.action.store) {
      Get.offNamed(AppRoutes.storeListScreen);
    } else if (action == AppConstants.action.stocks) {
      Get.offNamed(AppRoutes.stockListScreen);
    } else if (action == AppConstants.action.suppliers) {
      Get.offNamed(AppRoutes.supplierListScreen);
    } else if (action == AppConstants.action.categories) {
      Get.offNamed(AppRoutes.categoryListScreen);
    }
  }

  void onBackPress() {
    if (fromNotification) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.back();
    }
  }
}
