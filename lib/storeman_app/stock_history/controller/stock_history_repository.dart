import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class StockHistoryRepository {
  void getStockHistory({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.stockHistory,
      queryParameters: queryParameters,
    ).getRequest(
      onSuccess: (data) {
        onSuccess?.call(data);
      },
      onError: (error) {
        if (onError != null) onError(error);
      },
    );
  }
}
