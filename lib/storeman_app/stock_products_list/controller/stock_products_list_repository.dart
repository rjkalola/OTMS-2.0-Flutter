import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class StockProductsListRepository {
  void getProducts({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.productsGet, queryParameters: queryParameters)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) {
        if (onError != null) onError(error);
      },
    );
  }

  void getInventoryResources({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.getInventoryResources,
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
