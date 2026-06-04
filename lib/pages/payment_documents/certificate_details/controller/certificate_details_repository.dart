import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/network/api_request.dart';

class CertificateDetailsRepository {
  void getCertificateDetail({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.certificatesDetail,
            queryParameters: queryParameters,
            isFormData: false)
        .getRequest(
      onSuccess: (data) => onSuccess!(data),
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void deleteCertificate({
    Map<String, dynamic>? data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.certificatesDelete,
            data: data,
            isFormData: false)
        .postRequest(
      onSuccess: (data) => onSuccess!(data),
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void replaceCertificate({
    multi.FormData? formData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.certificatesReplace,
            formData: formData,
            isFormData: true)
        .postRequest(
      onSuccess: (data) => onSuccess!(data),
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
