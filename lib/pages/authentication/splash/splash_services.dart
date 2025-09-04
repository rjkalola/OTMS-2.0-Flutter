import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/res/theme/theme_controller.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/web_services/api_constants.dart';

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
        NotificationService.notificationClick(message.data);
        // _handleNotificationNavigation(message);
        return;
      }

      // Tapping notification (background)
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // NotificationService.handleMessageNavigation(message);
        NotificationService.notificationClick(message.data);
        // _handleMessageNavigation(message);
      });

      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        NotificationService.showForegroundNotification(message);
      });
    }

    Timer(const Duration(seconds: 1), () async {
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
  }
}
