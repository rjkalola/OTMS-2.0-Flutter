import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/authentication/splash/splash_services.dart';
import 'package:otm_inventory/res/drawable.dart';

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
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
              child: Image.asset(
            Drawable.splashScreenLogo,
            height: 350,
            width: 350,
          )),
        ));
  }
}
