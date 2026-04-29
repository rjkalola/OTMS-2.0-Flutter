import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class AnnouncementTabRepository {
  void getAnnouncementList({
    Map<String, dynamic>? queryParameters,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.getAnnouncementList,
            queryParameters: queryParameters)
        .getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void storeFeed({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
      url: ApiConstants.announcementStoreFeed,
      data: data,
      isFormData: false,
    ).postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
