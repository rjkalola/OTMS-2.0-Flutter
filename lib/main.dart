import 'package:belcka/utils/notification_service.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/splash/splash_screen.dart';
import 'package:belcka/res/strings.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/res/theme/theme_controller.dart';
import 'package:belcka/routes/app_pages.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Get.put(AppStorage()).initStorage();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
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
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        title: 'app_title'.tr,
        translations: Strings(),
        locale: const Locale('en', 'us'),
        getPages: AppPages.list,
        // theme: ThemeData(
        //     colorScheme: ColorScheme.fromSeed(seedColor: defaultAccentColor),
        //     useMaterial3: true,
        //     dialogBackgroundColor: Colors.white),
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode:
            themeController.isDarkMode ? ThemeMode.light : ThemeMode.dark,
        home: SplashScreen(),
      ),
    );
  }
}
