import 'package:flutter_task/view/profile_screen.dart';
import 'package:flutter_task/view/rendum_image_screen.dart';
import 'package:get/get.dart';

import '../view/spash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static get routes => [
        //login Module
        GetPage(
            name: AppRoutes.splashScreen,
            page: () => SplashScreen(),
            transition: Transition.zoom),
               GetPage(
            name: AppRoutes.rendomImageScreen,
            page: () => RendomImageScreen(),
            transition: Transition.rightToLeftWithFade),
                GetPage(
            name: AppRoutes.profileScreen,
            page: () => ProfileScreen(),
            transition: Transition.rightToLeftWithFade),
      ];
}
