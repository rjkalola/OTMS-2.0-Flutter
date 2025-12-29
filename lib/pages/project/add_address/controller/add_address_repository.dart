import 'dart:convert';

import 'package:belcka/pages/profile/post_coder_search/controller/post_coder_search_repository.dart';
import 'package:belcka/pages/profile/post_coder_search/model/post_coder_model.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/network/api_request.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:http/http.dart' as http;

class AddAddressRepository {
  void addAddress({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.addressCreate, data: data, isFormData: false)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void updateAddress({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.addressUpdate, data: data, isFormData: false)
        .putRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void deleteAddress({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.addressDelete, queryParameters: data, isFormData: false)
        .deleteRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void archiveAddress({
    dynamic data,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(url: ApiConstants.addressArchive, data: data, isFormData: false)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  Future<List<PostCoderModel>> getAddresses({
    required String postcode,
    required int page,
    required String countryCode,
  }) async {
    final url = Uri.parse(
      "${PostCoderApiConfig.baseUrl}/address/$countryCode/$postcode?page=$page",
    );

    final response = await http.get(url);

    print("RAW RESPONSE = ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((e) => PostCoderModel.fromJson(e)).toList();
      } else {
        throw "invalidFormat";
      }
    } else if (response.statusCode == 404) {
      throw "noResultsFound";
    } else {
      throw "apiError";
    }
  }
}
