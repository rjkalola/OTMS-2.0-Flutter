import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/introduction/view/introduction_screen.dart';
import 'package:otm_inventory/pages/authentication/login/view/login_screen.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/view/team_users_count_info_screen.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step2_business_field_info/view/business_field_info_screen.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step3_select_tools/view/select_tools_screen.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/view/verify_otp_screen.dart';
import 'package:otm_inventory/pages/authentication/signup1/view/signup1_screen.dart';
import 'package:otm_inventory/pages/authentication/signup2/view/signup2_screen.dart';
import 'package:otm_inventory/pages/authentication/splash/splash_screen.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/clock_in_screen.dart';
import 'package:otm_inventory/pages/check_in/select_address/view/select_address_screen.dart';
import 'package:otm_inventory/pages/check_in/select_before_after_photos/view/select_before_after_photos_screen.dart';
import 'package:otm_inventory/pages/dashboard/view/dashboard_screen.dart';
import 'package:otm_inventory/pages/company/company_details/view/company_details_screen.dart';
import 'package:otm_inventory/pages/company/company_signup/view/company_signup_screen.dart';
import 'package:otm_inventory/pages/company/joincompany/view/join_comapny_screen.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/view/select_company_trade_screen.dart';
import 'package:otm_inventory/pages/qr_code_scanner/view/qr_code_scanner.dart';
import 'package:otm_inventory/pages/trades/view/company_trades_screen.dart';
import '../pages/stock_filter/view/stock_filter_screen.dart';
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
      name: AppRoutes.stockFilterScreen,
      page: () => StockFilterScreen(),
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
      name: AppRoutes.selectAddressScreen,
      page: () => SelectAddressScreen(),
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
  ];
}
