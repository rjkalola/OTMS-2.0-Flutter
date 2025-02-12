class ApiConstants {
  static String appUrl = "https://api.otmsystem.com/v1";

  // static String appUrl = "https://apidev.otmsystem.com/v1";

  // static String appUrl = "https://dev.otmsystem.com/api/v1";
  // static String appUrl = "https://otmsystem.com/api/v1";

  static String accessToken = "";
  static const CODE_NO_INTERNET_CONNECTION = 10000;

  static Map<String, String> getHeader() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
  }

  static String registerResourcesUrl = '$appUrl/wn-resources';
  static String verifyPhoneUrl = '$appUrl/verify-phone';
  static String loginUrl = '$appUrl/login-new';
  static String logoutUrl = '$appUrl/logout';
  static String checkPhoneNumberExistUrl = '$appUrl/check-phone-exist';

  static String getStoreListUrl = '$appUrl/stores/get';
  static String stockFilterUrl = '$appUrl/products/category-filter';
  static String getDashboardStockCount = '$appUrl/dashboard/get-count';
  static String getSettingsUrl = '$appUrl/get-setting';

}
