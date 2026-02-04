import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class MyAccountRepository {
  void getProfile({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.userProfile,
            queryParameters: queryParameters,
            isFormData: false)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void removeUserPermanently({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.removeUserPermanently,
            data: data,
            isFormData: false)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void changeAdmin({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.changeAdmin, data: data, isFormData: false)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void archiveUser({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.archiveUserAccount, data: data, isFormData: false)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void stopUserWork({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.stopUserWork, data: data, isFormData: false)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
