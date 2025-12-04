import 'package:belcka/pages/add_trades/view/add_trades_screen.dart';
import 'package:belcka/pages/authentication/introduction/view/introduction_screen.dart';
import 'package:belcka/pages/authentication/login/view/login_screen.dart';
import 'package:belcka/pages/authentication/other_info_steps/step1_team_users_count_info/view/team_users_count_info_screen.dart';
import 'package:belcka/pages/authentication/other_info_steps/step2_business_field_info/view/business_field_info_screen.dart';
import 'package:belcka/pages/authentication/other_info_steps/step3_select_tools/view/select_tools_screen.dart';
import 'package:belcka/pages/authentication/otp_verification/view/verify_otp_screen.dart';
import 'package:belcka/pages/authentication/signup1/view/signup1_screen.dart';
import 'package:belcka/pages/authentication/signup2/view/signup2_screen.dart';
import 'package:belcka/pages/authentication/splash/splash_screen.dart';
import 'package:belcka/pages/authentication/update_sign_up_details/view/update_sign_up_details_screen.dart';
import 'package:belcka/pages/check_in/check_in/view/check_in_screen.dart';
import 'package:belcka/pages/check_in/check_in_day_logs/view/check_in_day_logs_screen.dart';
import 'package:belcka/pages/check_in/check_in_photos_preview/view/check_in_photos_preview_screen.dart';
import 'package:belcka/pages/check_in/check_log_details/view/check_log_details_screen.dart';
import 'package:belcka/pages/check_in/check_out/view/check_out_screen.dart';
import 'package:belcka/pages/check_in/clock_in/view/clock_in_screen.dart';
import 'package:belcka/pages/check_in/penalty/penalty_list/view/penalty_list_screen.dart';
import 'package:belcka/pages/check_in/select_before_after_photos/view/select_before_after_photos_screen.dart';
import 'package:belcka/pages/check_in/select_project/view/select_project_screen.dart';
import 'package:belcka/pages/check_in/select_shift/view/select_shift_screen.dart';
import 'package:belcka/pages/check_in/start_shift_map/view/start_shift_map_screen.dart';
import 'package:belcka/pages/check_in/stop_shift/view/stop_shift_screen.dart';
import 'package:belcka/pages/check_in/type_of_work_details/view/type_of_work_details_screen.dart';
import 'package:belcka/pages/check_in/work_log_request/view/work_log_request_screen.dart';
import 'package:belcka/pages/company/company_details/view/company_details_screen.dart';
import 'package:belcka/pages/company/company_list/view/company_list_screen.dart';
import 'package:belcka/pages/company/company_signup/view/company_signup_screen.dart';
import 'package:belcka/pages/company/joincompany/view/join_comapny_screen.dart';
import 'package:belcka/pages/company/selectcompanytrade/view/select_company_trade_screen.dart';
import 'package:belcka/pages/company/switch_company/view/switch_company_screen.dart';
import 'package:belcka/pages/dashboard/view/dashboard_screen.dart';
import 'package:belcka/pages/digital_id_card/view/digital_id_card_screen.dart';
import 'package:belcka/pages/expense/add_expense/view/add_expense_screen.dart';
import 'package:belcka/pages/filter/view/filter_screen.dart';
import 'package:belcka/pages/image_preview/view/image_preview_screen.dart';
import 'package:belcka/pages/leaves/add_leave/view/create_leave_screen.dart';
import 'package:belcka/pages/leaves/leave_details/view/leave_details_screen.dart';
import 'package:belcka/pages/leaves/leave_list/view/leave_list_screen.dart';
import 'package:belcka/pages/my_requests/view/my_requests_screen.dart';
import 'package:belcka/pages/notifications/announcement_details/view/announcement_details_screen.dart';
import 'package:belcka/pages/notifications/create_announcement/view/create_announcement_screen.dart';
import 'package:belcka/pages/notifications/notification_list/view/notification_list_screen.dart';
import 'package:belcka/pages/notifications/notification_settings/view/notification_settings_screen.dart';
import 'package:belcka/pages/permissions/company_permissions/view/company_permission_screen.dart';
import 'package:belcka/pages/permissions/permission_users/view/permission_users_screen.dart';
import 'package:belcka/pages/permissions/search_user/view/search_user_screen.dart';
import 'package:belcka/pages/permissions/user_list/view/select_user_list_for_permission_screen.dart';
import 'package:belcka/pages/permissions/user_permissions/view/user_permission_screen.dart';
import 'package:belcka/pages/permissions/widgets/view/widgets_screen.dart';
import 'package:belcka/pages/profile/billing_details_new/view/billing_details_new_screen.dart';
import 'package:belcka/pages/profile/billing_info/view/billing_info_screen.dart';
import 'package:belcka/pages/profile/billing_request/view/billing_request_screen.dart';
import 'package:belcka/pages/profile/company_billings/view/company_billings_screen.dart';
import 'package:belcka/pages/profile/delete_account/view/delete_account_screen.dart';
import 'package:belcka/pages/profile/my_account/view/my_account_screen.dart';
import 'package:belcka/pages/profile/my_profile_details/view/my_profile_details_screen.dart';
import 'package:belcka/pages/profile/other_user_billing/billing_details/view/other_user_billing_details_screen.dart';
import 'package:belcka/pages/profile/post_coder_search/view/post_coder_search_screen.dart';
import 'package:belcka/pages/profile/rates/view/rates_screen.dart';
import 'package:belcka/pages/profile/rates_history/view/rates_history_screen.dart';
import 'package:belcka/pages/profile/rates_request/view/rates_request_screen.dart';
import 'package:belcka/pages/profile/user_settings/view/user_settings_screen.dart';
import 'package:belcka/pages/project/add_address/view/add_address_screen.dart';
import 'package:belcka/pages/project/add_project/view/add_project_screen.dart';
import 'package:belcka/pages/project/address_details/view/address_details_screen.dart';
import 'package:belcka/pages/project/address_documents/view/address_documents_screen.dart';
import 'package:belcka/pages/project/address_list/view/address_list_screen.dart';
import 'package:belcka/pages/project/archive_addresses/view/archive_address_list_screen.dart';
import 'package:belcka/pages/project/archive_projects/view/archive_project_list_screen.dart';
import 'package:belcka/pages/project/check_in_records/view/check_in_records_screen.dart';
import 'package:belcka/pages/project/project_details/view/project_details_screen.dart';
import 'package:belcka/pages/project/project_info/view/project_info_screen.dart';
import 'package:belcka/pages/project/project_list/view/project_list_screen.dart';
import 'package:belcka/pages/project/trade_records/trade_records_screen.dart';
import 'package:belcka/pages/qr_code_scanner/view/qr_code_scanner.dart';
import 'package:belcka/pages/settings/view/settings_screen.dart';
import 'package:belcka/pages/shifts/archive_shift_list/view/archive_shift_list_screen.dart';
import 'package:belcka/pages/shifts/create_shift/view/create_shift_screen.dart';
import 'package:belcka/pages/shifts/shift_list/view/shift_list_screen.dart';
import 'package:belcka/pages/teams/archive_team_list/view/archive_team_list_screen.dart';
import 'package:belcka/pages/teams/create_team/view/create_team_screen.dart';
import 'package:belcka/pages/teams/generate_company_code/view/generate_company_code_screen.dart';
import 'package:belcka/pages/teams/join_team_to_company/view/join_team_to_company_screen.dart';
import 'package:belcka/pages/teams/sub_contractor_details/view/sub_contractor_details_screen.dart';
import 'package:belcka/pages/teams/team_details/view/team_details_screen.dart';
import 'package:belcka/pages/teams/team_generate_otp/view/team_generate_otp_screen.dart';
import 'package:belcka/pages/teams/team_list/view/team_list_screen.dart';
import 'package:belcka/pages/timesheet/add_time_sheet/view/add_time_sheet_screen.dart';
import 'package:belcka/pages/timesheet/archive_timesheet_list/view/archive_timesheet_list_screen.dart';
import 'package:belcka/pages/timesheet/timesheet_list/view/timesheet_list_screen.dart';
import 'package:belcka/pages/trades/view/company_trades_screen.dart';
import 'package:belcka/pages/users/archive_user_list/view/archive_user_list_screen.dart';
import 'package:belcka/pages/users/invite_user/view/invite_user_screen.dart';
import 'package:belcka/pages/users/user_list/view/user_list_screen.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.introductionScreen,
      page: () => IntroductionScreen(),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.signUp1Screen,
      page: () => SignUp1Screen(),
    ),
    GetPage(
      name: AppRoutes.updateSignUpDetailsScreen,
      page: () => UpdateSignUpDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.signUp2Screen,
      page: () => SignUp2Screen(),
    ),
    GetPage(
      name: AppRoutes.verifyOtpScreen,
      page: () => VerifyOtpScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboardScreen,
      page: () => DashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.joinCompanyScreen,
      page: () => JoinCompanyScreen(),
    ),
    GetPage(
      name: AppRoutes.selectCompanyTradeScreen,
      page: () => SelectCompanyTradeScreen(),
    ),
    GetPage(
      name: AppRoutes.qrCodeScannerScreen,
      page: () => QrCodeScanner(),
    ),
    GetPage(
      name: AppRoutes.companySignUpScreen,
      page: () => CompanySignUpScreen(),
    ),
    GetPage(
      name: AppRoutes.clockInScreen,
      page: () => ClockInScreen(),
    ),
    GetPage(
      name: AppRoutes.selectBeforeAfterPhotosScreen,
      page: () => SelectBeforeAfterPhotosScreen(),
    ),
    GetPage(
      name: AppRoutes.teamUsersCountInfoScreen,
      page: () => TeamUsersCountInfoScreen(),
    ),
    GetPage(
      name: AppRoutes.businessFieldInfoScreen,
      page: () => BusinessFieldInfoScreen(),
    ),
    GetPage(
      name: AppRoutes.selectToolScreen,
      page: () => SelectToolsScreen(),
    ),
    GetPage(
      name: AppRoutes.companyDetailsScreen,
      page: () => CompanyDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.companyTradesScreen,
      page: () => CompanyTradesScreen(),
    ),
    GetPage(name: AppRoutes.addTradesScreen, page: () => AddTradesScreen()),
    GetPage(
      name: AppRoutes.companyPermissionScreen,
      page: () => CompanyPermissionScreen(),
    ),
    GetPage(
      name: AppRoutes.widgetsScreen,
      page: () => WidgetsScreen(),
    ),
    GetPage(
      name: AppRoutes.userPermissionScreen,
      page: () => UserPermissionScreen(),
    ),
    GetPage(
      name: AppRoutes.permissionUsersScreen,
      page: () => PermissionUsersScreen(),
    ),
    GetPage(
      name: AppRoutes.teamListScreen,
      page: () => TeamListScreen(),
    ),
    GetPage(
      name: AppRoutes.teamGenerateOtpScreen,
      page: () => TeamGenerateOtpScreen(),
    ),
    GetPage(
      name: AppRoutes.selectUserListForPermissionScreen,
      page: () => SelectUserListForPermissionScreen(),
    ),
    GetPage(
      name: AppRoutes.searchUserScreen,
      page: () => SearchUserScreen(),
    ),
    GetPage(
      name: AppRoutes.settingsScreen,
      page: () => SettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.createTeamScreen,
      page: () => CreateTeamScreen(),
    ),
    GetPage(
      name: AppRoutes.teamDetailsScreen,
      page: () => TeamDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.joinTeamToCompanyScreen,
      page: () => JoinTeamToCompanyScreen(),
    ),
    GetPage(
      name: AppRoutes.generateCompanyCodeScreen,
      page: () => GenerateCompanyCodeScreen(),
    ),
    GetPage(
      name: AppRoutes.subContractorDetailsScreen,
      page: () => SubContractorDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.userListScreen,
      page: () => UserListScreen(),
    ),
    GetPage(
      name: AppRoutes.archiveUserListScreen,
      page: () => ArchiveUserListScreen(),
    ),
    GetPage(
      name: AppRoutes.archiveTeamListScreen,
      page: () => ArchiveTeamListScreen(),
    ),
    GetPage(
      name: AppRoutes.createShiftScreen,
      page: () => CreateShiftScreen(),
    ),
    GetPage(
      name: AppRoutes.shiftListScreen,
      page: () => ShiftListScreen(),
    ),
    GetPage(
        name: AppRoutes.archiveShiftListScreen,
        page: () => ArchiveShiftListScreen()),
    GetPage(
        name: AppRoutes.startShiftMapScreen, page: () => StartShiftMapScreen()),
    GetPage(name: AppRoutes.billingInfoScreen, page: () => BillingInfoScreen()),
    // GetPage(
    //     name: AppRoutes.billingDetailsScreen,
    //     page: () => BillingDetailsScreen()),
    GetPage(
        name: AppRoutes.companyBillingsScreen,
        page: () => CompanyBillingsScreen()),
    GetPage(name: AppRoutes.stopShiftScreen, page: () => StopShiftScreen()),
    GetPage(name: AppRoutes.selectShiftScreen, page: () => SelectShiftScreen()),
    GetPage(
        name: AppRoutes.timeSheetListScreen, page: () => TimeSheetListScreen()),
    GetPage(name: AppRoutes.myRequestsScreen, page: () => MyRequestsScreen()),
    GetPage(
        name: AppRoutes.billingRequestScreen,
        page: () => BillingRequestScreen()),
    GetPage(
        name: AppRoutes.workLogRequestScreen,
        page: () => WorkLogRequestScreen()),
    GetPage(
        name: AppRoutes.postCoderSearchScreen,
        page: () => PostCoderSearchScreen()),
    GetPage(name: AppRoutes.myAccountScreen, page: () => MyAccountScreen()),
    GetPage(
        name: AppRoutes.billingDetailsNewScreen,
        page: () => BillingDetailsNewScreen()),
    GetPage(
        name: AppRoutes.userSettingsScreen, page: () => UserSettingsScreen()),
    GetPage(
        name: AppRoutes.switchCompanyScreen, page: () => SwitchCompanyScreen()),
    GetPage(
        name: AppRoutes.billingDetailsNewScreen,
        page: () => BillingDetailsNewScreen()),
    GetPage(
        name: AppRoutes.userSettingsScreen, page: () => UserSettingsScreen()),
    GetPage(
        name: AppRoutes.deleteAccountScreen, page: () => DeleteAccountScreen()),
    GetPage(name: AppRoutes.filterScreen, page: () => FilterScreen()),
    GetPage(name: AppRoutes.companyListScreen, page: () => CompanyListScreen()),
    GetPage(name: AppRoutes.addProjectScreen, page: () => AddProjectScreen()),
    GetPage(name: AppRoutes.projectListScreen, page: () => ProjectListScreen()),
    GetPage(name: AppRoutes.projectInfoScreen, page: () => ProjectInfoScreen()),
    GetPage(name: AppRoutes.checkInScreen, page: () => CheckInScreen()),
    GetPage(name: AppRoutes.checkOutScreen, page: () => CheckOutScreen()),
    GetPage(
        name: AppRoutes.selectProjectScreen, page: () => SelectProjectScreen()),
    GetPage(name: AppRoutes.addressListScreen, page: () => AddressListScreen()),
    GetPage(
        name: AppRoutes.projectDetailsScreen,
        page: () => ProjectDetailsScreen()),
    GetPage(
        name: AppRoutes.archiveProjectListScreen,
        page: () => ArchiveProjectListScreen()),
    GetPage(
        name: AppRoutes.checkLogDetailsScreen,
        page: () => CheckLogDetailsScreen()),
    GetPage(
      name: AppRoutes.imagePreviewScreen,
      page: () => ImagePreviewScreen(),
    ),
    GetPage(name: AppRoutes.addAddressScreen, page: () => AddAddressScreen()),
    GetPage(
        name: AppRoutes.addressDetailsScreen,
        page: () => AddressDetailsScreen()),
    GetPage(
        name: AppRoutes.archiveAddressListScreen,
        page: () => ArchiveAddressListScreen()),
    GetPage(
        name: AppRoutes.addressDocumentsScreen,
        page: () => AddressDocumentsScreen()),
    GetPage(
        name: AppRoutes.checkInRecordsScreen,
        page: () => CheckInRecordsScreen()),
    GetPage(
        name: AppRoutes.tradeRecordsScreen, page: () => TradeRecordsScreen()),
    GetPage(
        name: AppRoutes.notificationSettingsScreen,
        page: () => NotificationSettingsScreen()),
    GetPage(
        name: AppRoutes.notificationListScreen,
        page: () => NotificationListScreen()),
    GetPage(name: AppRoutes.ratesScreen, page: () => RatesScreen()),
    GetPage(
        name: AppRoutes.ratesRequestScreen, page: () => RatesRequestScreen()),
    GetPage(
        name: AppRoutes.myProfileDetailsScreen,
        page: () => MyProfileDetailsScreen()),
    GetPage(
        name: AppRoutes.addTimeSheetScreen, page: () => AddTimeSheetScreen()),
    GetPage(
        name: AppRoutes.archiveTimeSheetListScreen,
        page: () => ArchiveTimesheetListScreen()),
    GetPage(
        name: AppRoutes.otherUserBillingDetailsScreen,
        page: () => OtherUserBillingDetailsScreen()),
    GetPage(
        name: AppRoutes.typeOfWorkDetailsScreen,
        page: () => TypeOfWorkDetailsScreen()),
    GetPage(
        name: AppRoutes.checkInPhotosPreviewScreen,
        page: () => CheckInPhotosPreviewScreen()),
    GetPage(
        name: AppRoutes.createAnnouncementScreen,
        page: () => CreateAnnouncementScreen()),
    GetPage(
        name: AppRoutes.ratesHistoryScreen, page: () => RatesHistoryScreen()),
    GetPage(
        name: AppRoutes.announcementDetailsScreen,
        page: () => AnnouncementDetailsScreen()),
    GetPage(name: AppRoutes.inviteUserScreen, page: () => InviteUserScreen()),
    GetPage(name: AppRoutes.createLeaveScreen, page: () => CreateLeaveScreen()),
    GetPage(name: AppRoutes.leaveListScreen, page: () => LeaveListScreen()),
    GetPage(
        name: AppRoutes.leaveDetailsScreen, page: () => LeaveDetailsScreen()),
    GetPage(name: AppRoutes.addExpenseScreen, page: () => AddExpenseScreen()),
    GetPage(
        name: AppRoutes.digitalIdCardScreen, page: () => DigitalIdCardScreen()),
    GetPage(name: AppRoutes.penaltyListScreen, page: () => PenaltyListScreen()),
    GetPage(
        name: AppRoutes.checkInDayLogsScreen,
        page: () => CheckInDayLogsScreen()),
  ];
}
