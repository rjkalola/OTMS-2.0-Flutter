import 'dart:convert';

import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_resource_response.dart';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_service.dart';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/hs_resource_types_info.dart';
import 'package:belcka/pages/profile/health_and_safety/hs_resource_types/hs_management_type.dart';
import 'package:belcka/pages/profile/health_and_safety/hs_resource_types/hs_resource_type_list_repository.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class HsResourceTypesListController extends GetxController{

  final _api = HsResourceTypeListRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  bool isDataUpdated = false;
  final healthAndSafetyService = Get.find<HealthAndSafetyService>();
  HSManagementType? selectedManagementType;
  RxString selectedTypeTitle = "".obs;
  final managementTypeList = <HSResourceTypesInfo>[].obs;

  RxString dialogueBoxTitle = "".obs;
  RxString dialogueBoxEditTitle = "".obs;
  RxString dialogueBoxLabel = "".obs;
  RxString noDataFoundMsg = "".obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      selectedManagementType = arguments["selectedManagementType"] ?? HSManagementType;
    }
    selectedTypeTitle.value = selectedManagementType?.title ?? "";

    if (selectedManagementType == HSManagementType.hazards){
      dialogueBoxTitle.value = "add_hazard";
      dialogueBoxEditTitle.value = "edit_hazard";
      dialogueBoxLabel.value = "hazard_title";
      noDataFoundMsg.value = "no_hazards_found";
      fetchHazards();
    }
    else if (selectedManagementType == HSManagementType.incidentTypes){
      dialogueBoxTitle.value = "add_incident_type";
      dialogueBoxEditTitle.value = "edit_incident_type";
      dialogueBoxLabel.value = "Incident_type_title";
      noDataFoundMsg.value = "no_incident_types_found";

      fetchIncidentTypes();
    }
    else{
      dialogueBoxTitle.value = "add_threat_level";
      dialogueBoxEditTitle.value = "edit_threat_level";
      dialogueBoxLabel.value = "threat_level_title";
      noDataFoundMsg.value = "no_threat_levels_found";

      fetchThreatLevels();
    }
  }

  void fetchHazards() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getHazardsAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          HealthAndSafetyResourceResponse response =
          HealthAndSafetyResourceResponse.fromJson(jsonDecode(responseModel.result!));
          managementTypeList.clear();
          managementTypeList.addAll(response.info);
          managementTypeList.refresh();
          isLoading.value = false;
          isMainViewVisible.value = true;
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

  void fetchIncidentTypes() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getIncidentsAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          HealthAndSafetyResourceResponse response =
          HealthAndSafetyResourceResponse.fromJson(jsonDecode(responseModel.result!));
          managementTypeList.clear();
          managementTypeList.addAll(response.info);
          managementTypeList.refresh();
          isLoading.value = false;
          isMainViewVisible.value = true;
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

  void fetchThreatLevels() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getThreatLevelsAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          HealthAndSafetyResourceResponse response =
          HealthAndSafetyResourceResponse.fromJson(jsonDecode(responseModel.result!));
          managementTypeList.clear();
          managementTypeList.addAll(response.info);
          managementTypeList.refresh();
          isLoading.value = false;
          isMainViewVisible.value = true;
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


  //Store actions
  void toggleStoreHazard(String title, int hazardId) async {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "title": title,
      "hazard_id": hazardId,
    };

    _api.storeHazardAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          try {
            fetchHazards();
            healthAndSafetyService.fetchResources();
            isLoading.value = false;
          }
          catch (e){
            isLoading.value = false;
          }
        } else {
          isLoading.value = false;
          if (responseModel.statusMessage != null) {
            AppUtils.showSnackBarMessage(responseModel.statusMessage!);
          }
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        AppUtils.showSnackBarMessage(error.statusMessage ?? "An error occurred");
      },
    );
  }

  void toggleStoreIncidentType(String title, int incidentId) async {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "title": title,
      "incident_type_id":incidentId
    };
    _api.storeIncidentTypeAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          try {
            fetchIncidentTypes();
            healthAndSafetyService.fetchResources();
            isLoading.value = false;
          }
          catch (e){
            isLoading.value = false;
          }
        } else {
          isLoading.value = false;
          if (responseModel.statusMessage != null) {
            AppUtils.showSnackBarMessage(responseModel.statusMessage!);
          }
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        AppUtils.showSnackBarMessage(error.statusMessage ?? "An error occurred");
      },
    );
  }

  void toggleThreatLevel(String title, int threatLevelId) async {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "title": title,
      "threat_level_id":threatLevelId
    };
    _api.storeThreatLevelAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          try {
            fetchThreatLevels();
            healthAndSafetyService.fetchResources();
            isLoading.value = false;
          }
          catch (e){
            isLoading.value = false;
          }
        } else {
          isLoading.value = false;
          if (responseModel.statusMessage != null) {
            AppUtils.showSnackBarMessage(responseModel.statusMessage!);
          }
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        AppUtils.showSnackBarMessage(error.statusMessage ?? "An error occurred");
      },
    );
  }

  void deleteHazardType(int id) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    _api.deleteHazardTypeAPI(
      id: id,
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          fetchHazards();
          healthAndSafetyService.fetchResources();
          AppUtils.showSnackBarMessage("hazard_deleted".tr);
        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
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

  void deleteIncidentType(int id) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    _api.deleteIncidentTypeAPI(
      id: id,
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          fetchIncidentTypes();
          healthAndSafetyService.fetchResources();
          AppUtils.showSnackBarMessage("incident_deleted".tr);
        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
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

  void deleteThreatLevel(int id) {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    _api.deleteThreatLevelAPI(
      id: id,
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.isSuccess) {
          fetchThreatLevels();
          healthAndSafetyService.fetchResources();
          AppUtils.showSnackBarMessage("threat_level_deleted".tr);
        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
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
    Get.back(result: isDataUpdated);
  }
}