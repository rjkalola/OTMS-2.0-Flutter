import 'dart:convert';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/pages/project/project_info/model/project_list_response.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProjectService extends GetxService {
  // Observable list accessible from anywhere
  var isLoading = false.obs;
  final projectsList = <ProjectInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects(); // Initial fetch when app starts
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

  void addProject(ProjectInfo newProject) {
    projectsList.add(newProject);
  }
}