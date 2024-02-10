import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/c_colors.dart';
import '../../../constants/imageConstants.dart';
import '../../../utils/display_utils.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CWhiteColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                ImageConstants.logoPng,
                height: getHeight(context) / 6,
              )),
            ],
          ),
        ),
      ),
    );
  }

  void initState() {
    getValidation();
    super.initState();
  }

  getValidation() async {
    Timer(Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.rendomImageScreen);
    });
  }
}
