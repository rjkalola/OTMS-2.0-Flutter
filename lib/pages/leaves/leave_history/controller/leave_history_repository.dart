import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class LeaveHistoryRepository {
  void getLeaveHistory({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.getHistory,
      queryParameters: queryParameters,
      isFormData: false,
    ).getRequest(
      onSuccess: (data) {
        onSuccess?.call(data);
      },
      onError: (error) {
        if (onError != null) {
          onError(error);
        }
      },
    );
  }
}
