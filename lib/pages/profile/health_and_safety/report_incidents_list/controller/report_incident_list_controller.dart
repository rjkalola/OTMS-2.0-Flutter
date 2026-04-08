import 'dart:convert';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/controller/near_miss_list_repository.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/near_miss_report_Info.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/near_miss_response.dart';
import 'package:belcka/pages/profile/health_and_safety/report_incidents_list/controller/report_incident_list_repository.dart';
import 'package:belcka/pages/profile/health_and_safety/report_incidents_list/model/incident_report_info.dart';
import 'package:belcka/pages/profile/health_and_safety/report_incidents_list/model/incidents_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class ReportIncidentListController extends GetxController{
  final _api = ReportIncidentListRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final incidentsReportsList = <IncidentReportInfo>[].obs;
  List<IncidentReportInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    fetchIncidentsReportsList();
  }

  void fetchIncidentsReportsList() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getIncidentsReportsListAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {

          IncidentsResponse response = IncidentsResponse.fromJson(
              jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);

          incidentsReportsList.value = tempList;
          incidentsReportsList.refresh();

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

    }
  }

  void onBackPress() {
    Get.back(result: true);
  }
}