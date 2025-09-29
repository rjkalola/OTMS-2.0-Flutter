import 'package:dio/dio.dart' as multi;
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class FullScreenImageViewRepository{
  void updateProfile({
    multi.FormData? formData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
        url: ApiConstants.updateProfile,
        formData: formData,
        isFormData: true)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}