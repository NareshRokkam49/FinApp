import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task/routes/app_pages.dart';
import 'package:flutter_task/routes/app_routes.dart';
import 'package:flutter_task/view_modals/rendom_viewmodal.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants/c_colors.dart';
import 'view_modals/profile_viewmodal.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Add this line

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

      SharedPreferences sp = await SharedPreferences.getInstance();
        String localCode= sp.getString("language_code")??" ";
  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(FinSolutionTask(local: localCode,));
  });
}

class FinSolutionTask extends StatelessWidget {
  final String local;
  FinSolutionTask({super.key,required this.local});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => RendomViewModal()),
            ChangeNotifierProvider(create: (context) => ProfileViewModal()),
          ],
          child: Consumer<RendomViewModal>(builder: (context, provider, child) {

            if (local.isEmpty) {
              provider.changeLanguage(Locale("en"));
              
            }
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.indigo,
                primaryColor: cPrimeryColor,
                textTheme:
                    GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
                fontFamily: "Inter",
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              initialRoute: AppRoutes.initial,
              getPages: AppPages.routes,
            locale:local==""?Locale("en") :provider.appLocale==null?Locale("en"):provider.appLocale,  
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate, //ios
              ],
              supportedLocales: [
                Locale('en'), // English
                Locale('es'), // Telugu
              ],
            );
          }));
    });
  }
}
