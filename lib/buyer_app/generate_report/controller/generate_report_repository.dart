import 'dart:convert';

import 'package:belcka/buyer_app/generate_report/model/generate_report_modules_response.dart';
import 'package:belcka/utils/download_save_path.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart';

class GenerateReportRepository {
  void getModules({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.getModules,
      queryParameters: queryParameters,
      isFormData: false,
    ).getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  GenerateReportModulesResponse? parseModulesResponse(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return null;
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return GenerateReportModulesResponse.fromJson(map);
  }

  Future<String> resolveDownloadPath(String fileName) {
    return resolveDownloadSavePath(fileName);
  }

  Future<String> downloadExportReport({
    required String startDate,
    required String endDate,
    required String reportType,
    required String moduleIds,
    required String fileName,
    void Function(int percent)? onProgress,
  }) async {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(minutes: 3);
    dio.options.receiveTimeout = const Duration(minutes: 3);
    final savePath = await resolveDownloadPath(fileName);
    await dio.download(
      ApiConstants.exportReports,
      savePath,
      queryParameters: {
        'company_id': ApiConstants.companyId.toString(),
        'start_date': startDate,
        'end_date': endDate,
        'report_type': reportType,
        'module_ids': moduleIds,
      },
      options: Options(headers: ApiConstants.getHeader()),
      onReceiveProgress: (received, total) {
        if (total != -1 && onProgress != null) {
          onProgress(((received / total) * 100).toInt());
        }
      },
    );
    return savePath;
  }
}
