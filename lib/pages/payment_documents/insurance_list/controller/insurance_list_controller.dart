import 'dart:convert';

import 'package:belcka/pages/payment_documents/certificates_list/model/certificate_info.dart';
import 'package:belcka/pages/payment_documents/certificates_list/model/certificates_list_response.dart';
import 'package:belcka/pages/payment_documents/insurance_list/controller/insurance_list_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class InsuranceListController extends GetxController {
  final _api = InsuranceListRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,
      isResetEnable = false.obs;

  final insuranceList = <CertificateInfo>[].obs;
  final RxInt selectedDateFilterIndex = 1.obs;

  String startDate = "";
  String endDate = "";
  int userId = 0;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? userId;
    }
    loadInsuranceList(true);
  }

  void loadInsuranceList(bool isProgress) {
    isLoading.value = isProgress;
    final map = <String, dynamic>{
      "company_id": ApiConstants.companyId,
      "start_date": startDate,
      "end_date": endDate,
    };
    if (userId > 0) {
      map["user_id"] = userId;
    }

    _api.getInsuranceList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CertificatesListResponse response = CertificatesListResponse.fromJson(
              jsonDecode(responseModel.result!));
          insuranceList
            ..clear()
            ..addAll(response.info ?? []);
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
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  String getItemColor(int? id, int index) {
    final seed = (id ?? index).abs();
    return DataUtils.listColors[seed % DataUtils.listColors.length];
  }

  Future<void> moveToCreateCertificate() async {
    final result = await Get.toNamed(AppRoutes.createCertificateScreen);
    if (result != null && result == true) {
      isDataUpdated.value = true;
      loadInsuranceList(true);
    }
  }

  void clearFilter() {
    isResetEnable.value = false;
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    loadInsuranceList(true);
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
}
