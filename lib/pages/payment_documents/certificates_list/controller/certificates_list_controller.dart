import 'dart:convert';
import 'package:belcka/pages/payment_documents/certificates_list/controller/certificates_list_repository.dart';
import 'package:belcka/pages/payment_documents/certificates_list/model/certificate_info.dart';
import 'package:belcka/pages/payment_documents/certificates_list/model/certificates_list_response.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class CertificatesListController extends GetxController {
  final _api = CertificatesListRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,
      isResetEnable = false.obs;

  final certificatesList = <CertificateInfo>[].obs;
  final RxInt selectedDateFilterIndex = 1.obs;

  String screenTitle = 'certificates'.tr;
  String? statusFilter;
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
    loadCertificatesList(true);
  }

  void loadCertificatesList(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    if (!StringHelper.isEmptyString(statusFilter)) {
      map["status"] = statusFilter;
    }
    if (userId > 0) {
      map["user_id"] = userId;
    }
    map["start_date"] = startDate;
    map["end_date"] = endDate;

    _api.getCertificatesList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CertificatesListResponse response = CertificatesListResponse.fromJson(
              jsonDecode(responseModel.result!));
          certificatesList
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
      loadCertificatesList(true);
    }
  }

  void clearFilter() {
    isResetEnable.value = false;
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    loadCertificatesList(true);
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
}
