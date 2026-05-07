import 'package:belcka/web_services/response/response_model.dart';

import '../../../../web_services/api_constants.dart';
import '../../../../web_services/network/api_request.dart';

class ConflictsRepository {
  void getConflicts({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.companyConflicts,
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
