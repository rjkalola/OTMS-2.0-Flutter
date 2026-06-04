import 'dart:convert';

import 'package:belcka/pages/payment_documents/expire_soon_certificates/controller/expire_soon_certificates_repository.dart';
import 'package:belcka/pages/payment_documents/expire_soon_certificates/model/expire_soon_certificates_response.dart';
import 'package:belcka/pages/payment_documents/expire_soon_certificates/model/expire_soon_section_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class ExpireSoonCertificatesController extends GetxController {
  final _api = ExpireSoonCertificatesRepository();

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isDataUpdated = false.obs,
      isResetEnable = false.obs;

  final sectionsList = <ExpireSoonSectionInfo>[].obs;
  final RxInt selectedDateFilterIndex = 1.obs;

  String startDate = "";
  String endDate = "";
  int userId = UserUtils.getLoginUserId();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? userId;
    }
    loadExpireSoonCertificates(true);
  }

  void loadExpireSoonCertificates(bool isProgress) {
    isLoading.value = isProgress;
    final map = <String, dynamic>{
      "company_id": ApiConstants.companyId,
      "start_date": startDate,
      "end_date": endDate,
    };
    if (userId > 0) {
      map["user_id"] = userId;
    }

    _api.getExpireSoonCertificates(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ExpireSoonCertificatesResponse response =
              ExpireSoonCertificatesResponse.fromJson(
                  jsonDecode(responseModel.result!));
          sectionsList
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

  bool get hasSections =>
      sectionsList.any((section) => (section.data?.isNotEmpty ?? false));

  String getItemColor(int? id, int index) {
    final seed = (id ?? index).abs();
    return DataUtils.listColors[seed % DataUtils.listColors.length];
  }

  void clearFilter() {
    isResetEnable.value = false;
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    loadExpireSoonCertificates(true);
  }

  void onBackPress() {
    Get.back(result: isDataUpdated.value);
  }
}
