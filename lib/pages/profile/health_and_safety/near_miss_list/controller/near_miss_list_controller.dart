import 'dart:convert';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_service.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/controller/near_miss_list_repository.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/near_miss_report_Info.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/near_miss_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class NearMissListController extends GetxController{
  final _api = NearMissListRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final nearMissReportsList = <NearMissReportInfo>[].obs;
  List<NearMissReportInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    Get.put(HealthAndSafetyService());
    fetchNearMissReportsList();
  }

  void fetchNearMissReportsList() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getNearMissReportsListAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {

          NearMissResponse response = NearMissResponse.fromJson(
              jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);

          nearMissReportsList.value = tempList;
          nearMissReportsList.refresh();

          isMainViewVisible.value = true;
          isLoading.value = false;

        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
          isLoading.value = false;
        }
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

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      fetchNearMissReportsList();
    }
  }

  void onBackPress() {
    Get.back(result: true);
  }
}