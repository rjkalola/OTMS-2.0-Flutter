import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/login/view/login_screen.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/view/team_users_count_info_screen.dart';
import 'package:otm_inventory/pages/authentication/splash/splash_screen.dart';
import 'package:otm_inventory/pages/dashboard/view/dashboard_screen.dart';
import 'package:otm_inventory/pages/managecompany/company_signup/view/company_signup_screen.dart';
import 'package:otm_inventory/pages/managecompany/joincompany/view/join_comapny_screen.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/strings.dart';
import 'package:otm_inventory/routes/app_pages.dart';
import 'package:otm_inventory/utils/app_storage.dart';

void main() async {
  await Get.put(AppStorage()).initStorage();
  // Get.lazyPut(() => HomeTabController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'app_title'.tr,
      translations: Strings(),
      locale: const Locale('en', 'us'),
      getPages: AppPages.list,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: defaultAccentColor),
          useMaterial3: true,
          dialogBackgroundColor: Colors.white),
      home: CompanySignUpScreen(),
    );
  }
}
