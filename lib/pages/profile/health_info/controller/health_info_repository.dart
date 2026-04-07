import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class HealthInfoRepository {
  void getHealthIssues({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.getHealthIssues,
      queryParameters: queryParameters,
      isFormData: false,
    ).getRequest(
      onSuccess: (data) => onSuccess!(data),
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void getHealthInfo({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.getHealthInfo,
      queryParameters: queryParameters,
      isFormData: false,
    ).getRequest(
      onSuccess: (data) => onSuccess!(data),
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void storeHealthInfo({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.storeHealthInfo, data: data, isFormData: false)
        .postRequest(
      onSuccess: (data) => onSuccess!(data),
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void updateHealthInfo({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.updateHealthInfo, data: data, isFormData: false)
        .putRequest(
      onSuccess: (data) => onSuccess!(data),
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
