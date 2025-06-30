class ApiConstants {
  // static String appUrl = "https://api.otmsystem.com/v1";
  // static String appUrl = "https://apidev.otmsystem.com/v1";

  // static String appUrl = "http://206.189.17.166:3000";
  // static String appUrl = "http://dev.belcka.com:3000";
  static String appUrl = "http://belcka.com:3003";

  // static String appUrl = "http://belcka.com:3000";

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

  // static String changeCompanyTradeStatus =
  //     '$appUrl/trade/change-company-trade-status';
  static String changeCompanyBulkTradeStatus =
      '$appUrl/trade/company/bulk-trade-status';

  //company permissions
  static String getCompanyPermissions = '$appUrl/dashboard/company/permissions';
  static String changeCompanyBulkPermissionStatus =
      '$appUrl/dashboard/company/change-bulk-permission-status';

  //system permissions
  static String getSystemPermissions = '$appUrl/dashboard/system/permissions';

  //user permissions
  static String getUserPermissions = '$appUrl/dashboard/user/permissions';

  // static String changeUserPermissionStatus =
  //     '$appUrl/dashboard/user/change-permission-status';
  static String changeUserBulkPermissionStatus =
      '$appUrl/dashboard/user/change-bulk-permission-status';

  //permission users
  static String getPermissionUsers =
      '$appUrl/dashboard/company/permission-users';
  static String changePermissionUserStatus =
      '$appUrl/dashboard/company/change-permission-users-status';

  // static String getPermissionUsers =
  //     '$appUrl/dashboard/company/users-permissions-status';
  // static String changePermissionUserStatus =
  //     '$appUrl/dashboard/company/change-users-permission-status';

  //users
  static String userList = '$appUrl/user/list';

  //teams
  static String teamList = '$appUrl/team/list';
  static String teamGenerateOtp = '$appUrl/team/generate-otp';
  static String teamAdd = '$appUrl/team/add';
  static String teamUpdate = '$appUrl/team/update-team';
  static String teamDetails = '$appUrl/team/details';
  static String teamDelete = '$appUrl/team/delete';
  static String generateCompanyCode = '$appUrl/team/company-generate-code';
  static String subContractorDetails = '$appUrl/team/subcontractor-details';
  static String addTeamToCompany = '$appUrl/company/add-team-to-company';
  static String archiveTeamList = '$appUrl/team/archive-list';
  static String teamArchive = '$appUrl/team/archive';
  static String teamUnArchive = '$appUrl/team/unarchive';

  //shifts
  static String shiftAdd = '$appUrl/shift/add';
  static String shiftEdit = '$appUrl/shift/edit';
  static String shiftDelete = '$appUrl/shift/delete';
  static String shiftList = '$appUrl/shift/list';
  static String archiveShiftList = '$appUrl/shift/archive-shifts';
  static String shiftArchive = '$appUrl/shift/archive';
  static String shiftUnArchive = '$appUrl/shift/unarchive';

  //billing info
  static String addBillingInfo = '$appUrl/user-billing/store-billing-info';
  static String updateBillingInfo = '$appUrl/user-billing/update-billing-info';
  static String getBillingInfo = '$appUrl/user-billing/get-billing-info';
  static String requestsGetRequestDetail =
      '$appUrl/requests/get-request-detail';

  //my requests
  static String getAllRequest = '$appUrl/requests/get-all-request';
  static String approveRequest = '$appUrl/requests/approve-request';
  static String rejectRequest = '$appUrl/requests/reject-request';

  //start work
  static String userStartWork = '$appUrl/user-start-work';
  static String userStopWork = '$appUrl/user-stop-work';
  static String userWorkLogList = '$appUrl/user-daylogs-list';
  static String requestWorkLogChange = '$appUrl/request-worklog-change';

  //timesheet
  static String getTimeSheetList = '$appUrl/timesheet/get';

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
