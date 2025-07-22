import 'dart:convert';

import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';
import 'package:otm_inventory/pages/common/listener/company_resources_listener.dart';
import 'package:otm_inventory/pages/company/company_details/controller/company_details_repository.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class CompanyResources {
  static void getResourcesApi(
      {required String flag, required CompanyResourcesListener listener}) {
    Map<String, dynamic> map = {};
    map["flag"] = flag;
    map["company_id"] = ApiConstants.companyId;
    CompanyDetailsRepository().getCompanyResourcesApi(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CompanyResourcesResponse response = CompanyResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          listener.onCompanyResourcesResponse(true, response, flag, true);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
          listener.onCompanyResourcesResponse(false, null, flag, true);
        }
      },
      onError: (ResponseModel error) {
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          listener.onCompanyResourcesResponse(false, null, flag, false);
        } else {
          listener.onCompanyResourcesResponse(false, null, flag, true);
        }
      },
    );
  }
}
