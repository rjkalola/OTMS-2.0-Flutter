import 'dart:convert';

import 'package:belcka/pages/payment_documents/payment_documents/model/payments_info.dart';
import 'package:belcka/pages/teams/sub_contractor_details/controller/sub_contractor_details_repository.dart';
import 'package:belcka/pages/teams/sub_contractor_details/model/sub_contractor_details_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class PaymentDetailsController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs;
  final paymentsInfo = PaymentsInfo().obs;
  final RxString currency = "".obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      paymentsInfo.value =
          arguments[AppConstants.intentKey.paymentsInfo] ?? PaymentsInfo();
      currency.value = paymentsInfo.value.currency ?? "";
    }
  }
}
