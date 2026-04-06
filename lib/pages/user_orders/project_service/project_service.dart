import 'dart:async';
import 'dart:convert';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/pages/user_orders/project_service/create_folder_response.dart';
import 'package:belcka/pages/user_orders/project_service/project_folder_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProjectService extends GetxService {
  // Observable list accessible from anywhere
  var isLoading = false.obs;
  final projectsList = <ProjectInfo>[].obs;
  final folderList = <ProjectFolderInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
    fetchProjectFolders(); // Initial fetch when app starts
  }

  Future<void> fetchProjects() async {
    try {
      Map<String, dynamic> map = {};
      map["company_id"] = ApiConstants.companyId;

      getProjectList(
        queryParameters: map,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            ProjectListResponse response =
            ProjectListResponse.fromJson(jsonDecode(responseModel.result!));
            projectsList.clear();
            projectsList.addAll(response.info!);
          }
        },
        onError: (ResponseModel error) {

        },
      );
    }
    finally{

    }
  }

  void getProjectList({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.getProjects, queryParameters: queryParameters)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  Future<void> fetchProjectFolders() async {
    try {
      Map<String, dynamic> map = {};
      map["company_id"] = ApiConstants.companyId;

      getProjectFolderListAPI(
        queryParameters: map,
        onSuccess: (ResponseModel responseModel) {
          if (responseModel.isSuccess) {
            ProjectFolderResponse response =
            ProjectFolderResponse.fromJson(jsonDecode(responseModel.result!));
            folderList.clear();
            if (response.info.isNotEmpty){
              folderList.addAll(response.info);
            }
          }
        },
        onError: (ResponseModel error) {

        },
      );
    }
    finally{

    }
  }

  void getProjectFolderListAPI({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.getProjectFolders, queryParameters: queryParameters)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

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
            fetchProjectFolders(); // Refresh list in background
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
}