import 'dart:async';

import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/web_services/api_constants.dart';

class SplashServices {
  void isLogin() {
    Timer(const Duration(seconds: 1), () async {
      ApiConstants.accessToken = Get.find<AppStorage>().getAccessToken();
      // Get.offAllNamed(AppRoutes.stockEditQuantityScreen);

      // List<UserInfo> list = Get.find<AppStorage>().getLoginUsers();
      // print("array length:"+list.length.toString());
      // AppStorage.uniqueId = await AppUtils.getDeviceUniqueId();
      // print("AppStorage.uniqueId:" + AppStorage.uniqueId);
      if (ApiConstants.accessToken.isNotEmpty) {
        Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.offAllNamed(AppRoutes.introductionScreen);
      }
    });
  }
}
