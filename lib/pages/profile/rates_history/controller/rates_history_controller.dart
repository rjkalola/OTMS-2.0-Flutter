import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/profile/rates_history/controller/rates_history_repository.dart';
import 'package:belcka/pages/profile/rates_history/model/rates_history_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';

class RatesHistoryController extends GetxController {

  final _api = RatesHistoryRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isResetEnable = false.obs;
  String startDate = "", endDate = "";

  final rateHistoryList = <RatesHistoryInfo>[].obs;
  List<RatesHistoryInfo> tempList = [];
  final RxInt selectedDateFilterIndex = (1).obs;
  Map<String, String> appliedFilters = {};

  @override
  void onInit() {
    super.onInit();
    getRateHistory(appliedFilters);
  }
  void getRateHistory(Map<String, String> appliedFilters) async {
    Map<String, dynamic> map = {};
    var arguments = Get.arguments;
    map["user_id"] =  arguments[AppConstants.intentKey.userId];
    map["company_id"] = ApiConstants.companyId;
    map["start_date"] = startDate;
    map["end_date"] = endDate;
    map["filters"] = appliedFilters;

    isLoading.value = true;
    _api.getRateHistoryAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {

          RatesHistoryResponse response =
          RatesHistoryResponse.fromJson(jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);

          final filteredList = tempList.where((item) {
            final isPendingRequested =
                (item.statusText ?? "").toLowerCase() == "pending" ||
                    item.actionBy == null;
            return !isPendingRequested;
          }).toList();

          rateHistoryList.value = filteredList;
          rateHistoryList.refresh();

          isMainViewVisible.value = true;
        }
        else{
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;

      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage);
        }
      },
    );
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      getRateHistory(appliedFilters);
    }
  }
  void clearFilter() {
    isResetEnable.value = false;
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    appliedFilters = {};
    getRateHistory(appliedFilters);
  }
}
