import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/network/api_request.dart';

class AddInvoiceRepository {
  void invoiceAdd({
    multi.FormData? formData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
            url: ApiConstants.invoiceAdd, formData: formData, isFormData: true)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

// void getActiveCompanyInfo({
//   Map<String, dynamic>? queryParameters,
//   Function(ResponseModel responseModel)? onSuccess,
//   Function(ResponseModel error)? onError,
// }) {
//   ApiRequest(
//       url: ApiConstants.inv,
//       queryParameters: queryParameters,
//       isFormData: false)
//       .getRequest(
//     onSuccess: (data) {
//       onSuccess!(data);
//     },
//     onError: (error) => {if (onError != null) onError(error)},
//   );
// }
}
