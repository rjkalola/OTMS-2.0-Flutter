import 'package:flutter/material.dart';
import 'package:belcka/pages/authentication/splash/splash_services.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: dashBoardBgColor_(context),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
              child: ImageUtils.setAssetsImage(
                  path: Drawable.imgHeaderLogo, width: 225, height: 90)),
        ));
  }
}
