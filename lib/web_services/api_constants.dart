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

  static String sendLoginOtpUrl = '$appUrl/send-otp-login';

  // static String verifyLoginOtpUrl = '$appUrl/verify-otp';
  static String loginUrl = '$appUrl/app-login';
  static String sendRegisterOtpUrl = '$appUrl/send-otp-register';
  static String verifyRegisterOtpUrl = '$appUrl/verify-register-otp';
  static String registerUrl = '$appUrl/app-registration';
  static String checkPhoneNumberExistUrl = '$appUrl/check-phone-exist';
  static String companyRegistrationUrl =
      '$appUrl/company/company-app-registration';

  static String registerResourcesUrl = '$appUrl/wn-resources';
  static String verifyPhoneUrl = '$appUrl/verify-phone';

  // static String loginUrl = '$appUrl/login-new';
  static String logoutUrl = '$appUrl/logout';

  // static String checkPhoneNumberExistUrl = '$appUrl/check-phone-exist';
  static String userSignUpUrl = '$appUrl/wn-kkm';
  static String getCompaniesUrl = '$appUrl/get-companies';
  static String joinCompanyCodeUrl = '$appUrl/join-company-code';
  static String scanInviteCodeUrl = '$appUrl/scan-invite-code';
  static String joinCompanyUrl = '$appUrl/join-company';
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
