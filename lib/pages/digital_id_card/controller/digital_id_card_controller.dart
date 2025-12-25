import 'dart:convert';
import 'dart:io';

import 'package:belcka/pages/digital_id_card/controller/digital_id_card_repository.dart';
import 'package:belcka/pages/digital_id_card/model/digital_id_card_info.dart';
import 'package:belcka/pages/digital_id_card/model/digital_id_card_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DigitalIdCardController extends GetxController {
  final _api = DigitalIdCardRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final digitalIdCardInfo = DigitalIdCardInfo().obs;
  int userId = 0;
  WebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
    }
    getDigitalCardDetailsApi();
  }

  void getDigitalCardDetailsApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["user_id"] = userId;
    _api.getDigitalCardDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          DigitalIdCardResponse response =
              DigitalIdCardResponse.fromJson(jsonDecode(responseModel.result!));
          digitalIdCardInfo.value = response.info!;
          // isMainViewVisible.value = true;
          // isLoading.value = false;
          if (!StringHelper.isEmptyString(
              digitalIdCardInfo.value.webUrl ?? "")) {
            loadWebData(digitalIdCardInfo.value.webUrl ?? "");
          }
        } else {
          isLoading.value = false;
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  Future<void> loadWebData(String url) async {
    String finalUrl = url;
    print("URL:" + url);
    print("finalUrl:" + finalUrl);
     webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            // isLoading.value = true;
          },
          onPageFinished: (_) {
            isMainViewVisible.value = true;
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}
