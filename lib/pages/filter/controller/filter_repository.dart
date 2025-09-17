import 'package:dio/dio.dart' as multi;
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';

class FilterRepository {
  void getFilters(
      {required String url,
      dynamic data,
      Function(ResponseModel responseModel)? onSuccess,
      Function(ResponseModel error)? onError}) {
    ApiRequest(url: url, data: data, isFormData: false).getRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
