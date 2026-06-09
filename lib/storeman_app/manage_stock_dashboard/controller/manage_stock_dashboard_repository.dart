import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class ManageStockDashboardRepository {
  void getStores({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.getStores, queryParameters: queryParameters)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) {
        if (onError != null) onError(error);
      },
    );
  }

  void getModules({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.getModules,
      queryParameters: queryParameters,
    ).getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) {
        if (onError != null) onError(error);
      },
    );
  }
}

