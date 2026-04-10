import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_resource_response.dart';
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

      getResourcesAPI(
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

  void getResourcesAPI({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.hsGetResources, queryParameters: queryParameters)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  /*
  //Create actions
  Future<CreatedFolder?> toggleCreateNewFolder(String name, int projectId) async {
    isLoading.value = true;
    // Change type to nullable CreatedFolder? to handle failures
    final completer = Completer<CreatedFolder?>();

    Map<String, dynamic> map = {
      "company_id": ApiConstants.companyId,
      "name": name,
      "project_id": projectId,
    };

    createFolderAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          try {
            // 1. Decode the string result into a Map
            Map<String, dynamic> jsonData = jsonDecode(responseModel.result!);

            // 2. Parse using your new CreateFolderResponse model
            final createResponse = CreateFolderResponse.fromJson(jsonData);

            // 3. Complete with the info object (contains the ID)
            fetchResources(); // Refresh list in background
            isLoading.value = false;
            completer.complete(createResponse.info);
          } catch (e) {
            isLoading.value = false;
            debugPrint("Parsing Error: $e");
            completer.complete(null);
          }
        } else {
          isLoading.value = false;
          if (responseModel.statusMessage != null) {
            AppUtils.showSnackBarMessage(responseModel.statusMessage!);
          }
          completer.complete(null);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        AppUtils.showSnackBarMessage(error.statusMessage ?? "An error occurred");
        completer.complete(null);
      },
    );

    return completer.future;
  }

  void createFolderAPI({
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
        url: ApiConstants.projectCreateFolder,
        data: data)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
  */
}