import 'dart:async';

import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SplashServices {
  Future<void> isLogin() async {
    Timer(const Duration(seconds: 2), () async {
      ApiConstants.accessToken = Get.find<AppStorage>().getAccessToken();
      ApiConstants.companyId = Get.find<AppStorage>().getCompanyId();
      // Get.offAllNamed(AppRoutes.stockEditQuantityScreen);

      // List<UserInfo> list = Get.find<AppStorage>().getLoginUsers();
      // print("array length:"+list.length.toString());
      // AppStorage.uniqueId = await AppUtils.getDeviceUniqueId();
      // print("AppStorage.uniqueId:" + AppStorage.uniqueId);
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
  }
}
