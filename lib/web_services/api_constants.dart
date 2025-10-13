class ApiConstants {
  // static String appUrl = "http://appdev.belcka.com:3000";

  static String appUrl = "http://app.belcka.com:3003";

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
  static String logoutUrl = '$appUrl/logout';

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
  static String getCompanyList = '$appUrl/company/list';
  static String getSwitchCompanyList = '$appUrl/user/switch-company-list';
  static String switchCompany = '$appUrl/company/switch-company';

  //dashboard
  static String changeDashboardUserPermissionSequenceUrl =
      '$appUrl/dashboard/user/change-permission-sequence';
  static String changeDashboardUserPermissionMultipleSequenceUrl =
      '$appUrl/dashboard/user/change-bulk-sequence';

  //trades
  static String getCompanyTradesUrl = '$appUrl/trade/get-company-trades';
  static String createTrade = '$appUrl/trade/create-trade';
  static String deleteCompanyBulkTrades =
      '$appUrl/trade/company/delete-bulk-trade-status';

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
  static String deleteSubContractor = '$appUrl/team/delete-subcontractor';
  static String addTeamToCompany = '$appUrl/company/add-team-to-company';
  static String archiveTeamList = '$appUrl/team/archive-list';
  static String teamArchive = '$appUrl/team/archive';
  static String teamUnArchive = '$appUrl/team/unarchive';
  static String teamUserList = '$appUrl/team/user-list';

  //shifts
  static String shiftAdd = '$appUrl/shift/add';
  static String shiftEdit = '$appUrl/shift/edit';
  static String shiftDelete = '$appUrl/shift/delete';
  static String shiftList = '$appUrl/shift/list';
  static String archiveShiftList = '$appUrl/shift/archive-shifts';
  static String shiftArchive = '$appUrl/shift/archive';
  static String shiftUnArchive = '$appUrl/shift/unarchive';
  static String changeShiftStatus = '$appUrl/shift/change-shift-status';

  //billing info
  static String addBillingInfo = '$appUrl/user-billing/store-billing-info';
  static String updateBillingInfo = '$appUrl/user-billing/update-billing-info';
  static String getBillingInfo = '$appUrl/user-billing/get-billing-info';
  static String requestsGetRequestDetail =
      '$appUrl/requests/get-request-detail';
  static String archiveAccount = '$appUrl/user/archive-account';
  static String changeCompanyRate = '$appUrl/user-billing/change-company-rate';

  //my requests
  static String getAllRequest = '$appUrl/requests/get-all-request';
  static String approveRequest = '$appUrl/requests/approve-request';
  static String rejectRequest = '$appUrl/requests/reject-request';

  //start work
  static String userStartWork = '$appUrl/user-start-work';
  static String userStopWork = '$appUrl/user-stop-work';
  static String userWorkLogList = '$appUrl/user-worklogs-list';
  static String getWorkLogDetails = '$appUrl/get-worklog-detail';
  static String requestWorkLogChange = '$appUrl/request-worklog-change';
  static String workLogRequestDetails = '$appUrl/requests/get-request-detail';
  static String workLogRequestApproveReject = '$appUrl/worklog-request/action';
  static String getLastWorkLog = '$appUrl/get-last-worklog';

  //check In
  static String checkIn = '$appUrl/check-in';
  static String checkout = '$appUrl/check-out';
  static String checkInResources = '$appUrl/user-checklog/get-resources';
  static String getTypeOfWorkResources =
      '$appUrl/company-tasks/get-task-resources';
  static String checkLogDetails = '$appUrl/user-checklog/details';
  static String getCompanyLocations = '$appUrl/company-locations/get';
  static String addCheckLogAttachments =
      '$appUrl/user-checklog/add-attachments';
  static String removeCheckLogAttachment =
      '$appUrl/user-checklog/remove-attachment';

  //timesheet
  static String getTimeSheetList = '$appUrl/timesheet/get';
  static String getTimeSheetListAllUsers =
      '$appUrl/timesheet/get-users-timesheet';
  static String getCheckLogDetails = '$appUrl/timesheet/get-checklog-details';
  static String archiveTimesheet = '$appUrl/timesheet/archive';
  static String unarchiveTimesheet = '$appUrl/timesheet/unarchive';
  static String addTimesheetWorkLog = '$appUrl/timesheet/save-worklog';
  static String lockTimesheet = '$appUrl/timesheet/approve';
  static String unlockTimesheet = '$appUrl/timesheet/unapprove';
  static String paidTimesheet = '$appUrl/timesheet/paid';

  //project
  static String addProject = '$appUrl/project/create';
  static String updateProject = '$appUrl/project/update';
  static String getProjects = '$appUrl/project/get';
  static String deleteProject = '$appUrl/project/delete';
  static String archiveProject = '$appUrl/project/archive';
  static String unarchiveProject = '$appUrl/project/unarchive';
  static String getProjectDetails = '$appUrl/project/project-detail';
  static String projectArchiveList = '$appUrl/project/archive-list';
  static String getProjectCheckLogs = '$appUrl/project/get-checklogs';
  static String getProjectTradeRecords = '$appUrl/trade/get-checklogs';

  //address
  static String getAddress = '$appUrl/address/get';
  static String addressCreate = '$appUrl/address/create';
  static String addressUpdate = '$appUrl/address/update';
  static String addressArchive = '$appUrl/address/archive';
  static String addressDelete = '$appUrl/address/delete';
  static String addressDetails = '$appUrl/address/address-detail';
  static String addressArchiveList = '$appUrl/address/archive-list';
  static String addressUnarchive = '$appUrl/address/unarchive';
  static String changeAddressProgress =
      '$appUrl/address/change-address-progress';

  static String registerResourcesUrl = '$appUrl/wn-resources';
  static String verifyPhoneUrl = '$appUrl/verify-phone';

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
  static String registerFcmUrl = '$appUrl/notifications/save-token';

  // Notification
  static String getUserNotificationSettings =
      '$appUrl/notifications/user-notifications';
  static String getCompanyNotificationSettings =
      '$appUrl/notifications/company-notifications';
  static String changeCompanyBulkNotificationSettings =
      '$appUrl/notifications/change-company-bulk-notifications';
  static String changeUserBulkNotificationSettings =
      '$appUrl/notifications/change-user-bulk-notifications';
  static String getFeedList = '$appUrl/get-feeds';
  static String createAnnouncement = '$appUrl/announcements/create';
  static String getAnnouncementList = '$appUrl/announcements/get-announcements';

  //my account
  static String userProfile = '$appUrl/user/profile';
  static String userPayRatePermission =
      '$appUrl/setting/user-payrate-permission';
  static String updateProfile = '$appUrl/user/update-profile';

  //filters
  static String getRequestFilters = '$appUrl/requests/get-filters';
  static String getTimesheetFilters = '$appUrl/timesheet/get-resources';
}
