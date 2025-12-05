import '../../../../web_services/api_constants.dart';
import '../../../../web_services/network/api_request.dart';
import '../../../../web_services/response/response_model.dart';

class CheckInDayLogsRepository {
  void getCheckInDayLogs({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.getCheckInDayLogs,
            queryParameters: queryParameters)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
