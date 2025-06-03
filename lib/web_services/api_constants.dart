class ApiConstants {
  // static String appUrl = "https://api.otmsystem.com/v1";
  // static String appUrl = "https://apidev.otmsystem.com/v1";

  static String appUrl = "http://206.189.17.166:3000";

  // static String appUrl = "https://dev.otmsystem.com/api/v1";
  // static String appUrl = "https://otmsystem.com/api/v1";

  static String accessToken = "";
  static int companyId = 0;
  static const CODE_NO_INTERNET_CONNECTION = 10000;

  static Map<String, String> getHeader() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
  }

  //login
  static String sendLoginOtpUrl = '$appUrl/send-otp-login';
  static String loginUrl = '$appUrl/app-login';

  //register
  static String sendRegisterOtpUrl = '$appUrl/send-otp-register';
  static String verifyRegisterOtpUrl = '$appUrl/verify-register-otp';
  static String registerUrl = '$appUrl/app-registration';
  static String checkPhoneNumberExistUrl = '$appUrl/check-phone-exist';

  //company
  static String getCompanyResourcesUrl = '$appUrl/get-company-resources';
  static String joinCompanyUrl = '$appUrl/company/join-company';
  static String storeTradeUrl = '$appUrl/company/add-trade';
  static String companyRegistrationUrl =
      '$appUrl/company/company-app-registration';
  static String storeCompanyDataUrl = '$appUrl/company/company-data/$companyId';
  static String editCompanyUrl = '$appUrl/company/edit-company';
  static String getCompanyDetailsUrl = '$appUrl/company/get-company';

  //dashboard
  static String changeDashboardUserPermissionSequenceUrl =
      '$appUrl/dashboard/user/change-permission-sequence';
  static String changeDashboardUserPermissionMultipleSequenceUrl =
      '$appUrl/dashboard/user/change-bulk-sequence';

  //trades
  static String getCompanyTradesUrl = '$appUrl/trade/get-company-trades';
  static String changeCompanyTradeStatus =
      '$appUrl/trade/change-company-trade-status';

  //company permissions
  static String getCompanyPermissions = '$appUrl/dashboard/company/permissions';

  // static String changeCompanyPermissionStatus =
  //     '$appUrl/dashboard/company/change-permission-status';
  static String changeCompanyBulkPermissionStatus =
      '$appUrl/dashboard/company/change-bulk-permission-status';

  //user permissions
  static String getUserPermissions = '$appUrl/dashboard/user/permissions';

  // static String changeUserPermissionStatus =
  //     '$appUrl/dashboard/user/change-permission-status';
  static String changeUserBulkPermissionStatus =
      '$appUrl/dashboard/user/change-bulk-permission-status';

  //permission users
  static String getPermissionUsers =
      '$appUrl/dashboard/company/users-permissions-status';
  static String changePermissionUserStatus =
      '$appUrl/dashboard/company/change-users-permission-status';

  //users
  static String userList = '$appUrl/user/list';

  //teams
  static String teamList = '$appUrl/team/list';
  static String teamGenerateOtp = '$appUrl/team/generate-otp';

  static String registerResourcesUrl = '$appUrl/wn-resources';
  static String verifyPhoneUrl = '$appUrl/verify-phone';

  // static String loginUrl = '$appUrl/login-new';
  static String logoutUrl = '$appUrl/logout';

  // static String checkPhoneNumberExistUrl = '$appUrl/check-phone-exist';
  static String userSignUpUrl = '$appUrl/wn-kkm';
  static String getCompaniesUrl = '$appUrl/get-companies';
  static String joinCompanyCodeUrl = '$appUrl/join-company-code';
  static String scanInviteCodeUrl = '$appUrl/scan-invite-code';

  // static String joinCompanyUrl = '$appUrl/join-company';
  static String newTimesheetResourcesUrl =
      '$appUrl/new-timesheet/get-resources';
  static String startWorkUrl = '$appUrl/start-time';
  static String stopWorkUrl = '$appUrl/stop-time';
  static String checkInUrl = '$appUrl/check-in';
  static String checkOutUrl = '$appUrl/check-out';

  static String stockFilterUrl = '$appUrl/products/category-filter';
  static String getDashboardStockCount = '$appUrl/dashboard/get-count';
  static String getDashboardResponse = '$appUrl/dashboard';
  static String getSettingsUrl = '$appUrl/get-setting';
  static String getRequestCountUrl = '$appUrl/get-request-count';
}
