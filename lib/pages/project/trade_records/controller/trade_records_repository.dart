import 'package:dio/dio.dart' as multi;
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/network/api_request.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class TradeRecordsRepository {
  void getProjectTradeRecords({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.getProjectTradeRecords, data: data).getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
