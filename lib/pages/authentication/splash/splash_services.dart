import 'dart:async';

import 'package:belcka/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:belcka/pages/dashboard/tabs/home_tab/controller/home_tab_controller.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/res/theme/theme_controller.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/notification_service.dart';
import '../../../utils/string_helper.dart';

class SplashServices {
  /* Future<void> isLogin() async {
    Timer(const Duration(seconds: 2), () async {
      ApiConstants.accessToken = Get.find<AppStorage>().getAccessToken();
      ApiConstants.companyId = Get.find<AppStorage>().getCompanyId();
      final controller = Get.put(ThemeController());
      ThemeConfig.isDarkMode = controller.isDarkMode;

      if (ApiConstants.accessToken.isNotEmpty) {
        if (ApiConstants.companyId != 0) {
          Get.offAllNamed(AppRoutes.dashboardScreen);
        } else {
          Get.offAllNamed(AppRoutes.joinCompanyScreen);
        }
        // Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.offAllNamed(AppRoutes.introductionScreen);
      }
    });
    // String? appSignature = await SmsAutoFill().getAppSignature;
    // AppUtils.showApiResponseMessage(appSignature);
    // print("App Signature: ${appSignature??""}");
  }*/

  void isLogin() {
    ApiConstants.accessToken = Get.find<AppStorage>().getAccessToken();
    ApiConstants.companyId = Get.find<AppStorage>().getCompanyId();
    final controller = Get.put(ThemeController());
    ThemeConfig.isDarkMode = controller.isDarkMode;
    initializeApp();
  }

  Future<void> initializeApp() async {
    // Handle initial notification (cold start)

    if (!StringHelper.isEmptyString(ApiConstants.accessToken)) {
      RemoteMessage? message =
          await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        refreshData(message.data);
        NotificationService.notificationClick(message.data);
        // _handleNotificationNavigation(message);
        return;
      }

      // Tapping notification (background)
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // NotificationService.handleMessageNavigation(message);
        print("message1::::" + message.data!.toString());
        refreshData(message.data);
        NotificationService.notificationClick(message.data);
        // _handleMessageNavigation(message);
      });

      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("message2::::" + message.data!.toString());
        refreshData(message.data);
        NotificationService.showForegroundNotification(message);
      });
    }

    Timer(const Duration(seconds: 1), () async {
      if (ApiConstants.accessToken.isNotEmpty) {
        if (ApiConstants.companyId != 0) {
          Get.offAllNamed(AppRoutes.dashboardScreen);
          // Get.offAllNamed(AppRoutes.paymentDocumentsScreen);
        } else {
          var arguments = {AppConstants.intentKey.fromSignUpScreen: true};
          Get.offAllNamed(AppRoutes.switchCompanyScreen, arguments: arguments);
        }
        // Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.offAllNamed(AppRoutes.introductionScreen);
      }
    });
  }

  Future<void> refreshData(Map<String, dynamic>? data) async {
    if (data != null) {
      final notificationType = data['notification_type'] ?? "";
      print("notificationType:::" + notificationType);
      if (notificationType ==
              AppConstants.notificationType.USER_WORK_STOP_AUTOMATICALLY ||
          notificationType ==
              AppConstants.notificationType.USER_WORK_STOP_BY_ADMIN) {
        if (Get.isRegistered<ClockInController>()) {
          final controller = Get.find<ClockInController>();
          controller.getUserWorkLogListApi(isProgress: false);
        }

        if (Get.isRegistered<HomeTabController>()) {
          final controller = Get.find<HomeTabController>();
          controller.getUserProfileAPI();
        }
      }
    }
  }
}
