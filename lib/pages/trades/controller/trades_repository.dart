import 'package:dio/dio.dart' as multi;
import 'package:flutter/foundation.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/network/api_request.dart';
import '../../../web_services/response/response_model.dart';

class TradesRepository {
  void getCompanyTradesApi({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.getCompanyTradesUrl,
            queryParameters: queryParameters)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void changeCompanyTradeStatus({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.changeCompanyTradeStatus,
            data: data,
            isFormData: false)
        .putRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
