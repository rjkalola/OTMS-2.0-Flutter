import 'package:dio/dio.dart' as multi;
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/network/api_request.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class TimesheetListRepository {
  void getTimeSheetList({
    // Map<String, dynamic>? queryParameters,
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.getTimeSheetList, data: data, isFormData: false)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void getTimeSheetListAllUsers({
    // Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.getTimeSheetListAllUsers,
            queryParameters: queryParameters,
            isFormData: false)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
