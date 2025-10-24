import 'package:belcka/web_services/response/response_model.dart';

import '../../../../web_services/api_constants.dart';
import '../../../../web_services/network/api_request.dart';

class InviteUserRepository {
  void inviteUser({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.inviteUser, data: data, isFormData: false)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

}
