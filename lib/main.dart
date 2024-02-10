import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task/routes/app_pages.dart';
import 'package:flutter_task/routes/app_routes.dart';
import 'package:flutter_task/view_modals/rendom_viewmodal.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'constants/c_colors.dart';
import 'view_modals/profile_viewmodal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(FinSolutionTask());
  });
}

class FinSolutionTask extends StatelessWidget {
  FinSolutionTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
       return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => RendomViewModal()),
          ChangeNotifierProvider(create: (context) => ProfileViewModal()),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            primaryColor: cPrimeryColor,
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
            fontFamily: "Inter",
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: AppRoutes.initial,
          getPages: AppPages.routes,
        ),
      );
    });

  }
}
