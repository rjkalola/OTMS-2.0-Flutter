import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_resource_response.dart';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_service_repository.dart';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/hs_resource_types_info.dart';
import 'package:belcka/pages/user_orders/project_service/create_folder_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HealthAndSafetyService extends GetxService {
  // Observable list accessible from anywhere
  final _api = HealthAndSafetyServiceRepository();
  var isLoading = false.obs;
  final users = <HSResourceTypesInfo>[].obs;
  final teams = <HSResourceTypesInfo>[].obs;
  final hazards = <HSResourceTypesInfo>[].obs;
  final incidentTypes = <HSResourceTypesInfo>[].obs;
  final threatLevels = <HSResourceTypesInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchResources();
  }

  //Data
  Future<void> fetchResources() async {
    try {
      Map<String, dynamic> map = {};
      map["company_id"] = ApiConstants.companyId;
      _api.getResourcesAPI(
        queryParameters: map,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            HealthAndSafetyResourceResponse response =
            HealthAndSafetyResourceResponse.fromJson(jsonDecode(responseModel.result!));

            users.clear();
            users.addAll(response.users);

            teams.clear();
            teams.addAll(response.teams);

            hazards.clear();
            hazards.addAll(response.hazards);

            incidentTypes.clear();
            incidentTypes.addAll(response.incidentTypes);

            threatLevels.clear();
            threatLevels.addAll(response.threatLevels);
          }
        },
        onError: (ResponseModel error) {

        },
      );
    }
    finally{

    }
  }

  //Store actions
  void toggleStoreHazard(String title) async {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "title": title,
    };

    _api.storeHazardAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          try {
            fetchResources();
            isLoading.value = false;
          }
          catch (e){
            isLoading.value = false;
            debugPrint("Parsing Error: $e");
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

}