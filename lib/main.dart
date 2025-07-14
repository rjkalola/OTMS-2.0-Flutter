import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/splash/splash_screen.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/strings.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/res/theme/theme_controller.dart';
import 'package:otm_inventory/routes/app_pages.dart';
import 'package:otm_inventory/utils/app_storage.dart';

void main() async {
  await Get.put(AppStorage()).initStorage();
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    // print(
    //     "themeController.isDarkMode:" + themeController.isDarkMode.toString());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      title: 'app_title'.tr,
      translations: Strings(),
      locale: const Locale('en', 'us'),
      getPages: AppPages.list,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: defaultAccentColor),
          useMaterial3: true,
          dialogBackgroundColor: Colors.white),
      // theme: ThemeConfig.lightTheme,
      // darkTheme: ThemeConfig.darkTheme,
      // themeMode: themeController.isDarkMode ? ThemeMode.light : ThemeMode.dark,
      home: SplashScreen(),
    );
  }
}
