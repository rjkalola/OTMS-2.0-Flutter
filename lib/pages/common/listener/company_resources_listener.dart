import 'package:belcka/pages/authentication/other_info_steps/step1_team_users_count_info/model/CompanyResourcesResponse.dart';

abstract class CompanyResourcesListener {
  void onCompanyResourcesResponse(bool isSuccess,
      CompanyResourcesResponse? response, String flag, bool isInternet);
}
