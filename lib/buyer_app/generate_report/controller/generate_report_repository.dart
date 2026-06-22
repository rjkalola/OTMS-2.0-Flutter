import 'dart:convert';
import 'dart:io';

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

  Future<String> downloadExportReport({
    required String startDate,
    required String endDate,
    required String reportType,
    required List<int> moduleIds,
    required String fileName,
    void Function(int percent)? onProgress,
  }) async {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(minutes: 3);
    dio.options.receiveTimeout = const Duration(minutes: 3);
    final stagingPath = await resolveDownloadStagingPath(fileName);
    final requestBody = {
      'company_id': ApiConstants.companyId,
      'start_date': startDate,
      'end_date': endDate,
      'report_type': reportType,
      'module_ids': moduleIds,
    };
    final response = await dio.post<List<int>>(
      ApiConstants.exportReports,
      data: requestBody,
      options: Options(
        headers: ApiConstants.getHeader(),
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) => status != null && status < 500,
      ),
      onReceiveProgress: (received, total) {
        if (total != -1 && onProgress != null) {
          onProgress(((received / total) * 100).toInt());
        }
      },
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Export report failed with status ${response.statusCode}',
      );
    }
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Export report returned empty file',
      );
    }
    await File(stagingPath).writeAsBytes(bytes, flush: true);
    return finalizeDownloadSave(
      stagingPath: stagingPath,
      fileName: fileName,
    );
  }
}
