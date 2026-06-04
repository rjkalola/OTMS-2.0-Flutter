import 'package:belcka/web_services/response/response_model.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/network/api_request.dart';

class ExpireSoonCertificatesRepository {
  void getExpireSoonCertificates({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.certificatesExpireSoon,
            queryParameters: queryParameters,
            isFormData: false)
        .getRequest(
      onSuccess: (data) => onSuccess!(data),
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
