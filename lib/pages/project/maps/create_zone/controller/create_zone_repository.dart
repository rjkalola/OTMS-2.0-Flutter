import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class CreateZoneRepository {
  void createZone({
    required Map<String, dynamic> data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.workZoneCreate, data: data, isFormData: false)
        .postRequest(
      onSuccess: (d) => onSuccess?.call(d),
      onError: (e) => onError?.call(e),
    );
  }

  void updateZone({
    required Map<String, dynamic> data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.workZoneUpdate, data: data, isFormData: false)
        .putRequest(
      onSuccess: (d) => onSuccess?.call(d),
      onError: (e) => onError?.call(e),
    );
  }
}
