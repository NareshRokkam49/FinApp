import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modals/res/rendom_dog_res.dart';
import '../modals/services/api_endpoint.dart';

class RendomViewModal with ChangeNotifier {
  RendomDogRes? rendomDogRes;

  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
   _appLocale=type;
    if (type == Locale("en")) {
      await sp.setString("language_code", "el");
    } else {
      await sp.setString("language_code", "es");
    }
    notifyListeners();
  }
  RendomViewModal() {
    initializeData();
  }
  Future<void> initializeData() async {
    await dataFromTheRendomDogImageApi();
   checkPermissions();
  }

  Future<void> dataFromTheRendomDogImageApi() async {
    try {
      Response rendomResponce = await Dio().get(
        ApiEndPoint.rendomApi,
      );
      final rendomresult = RendomDogRes.fromJson(rendomResponce.data);
      rendomDogRes = rendomresult;
         
      notifyListeners();
    } on DioException catch (e) {
      print(e);
    }
  }

void checkPermissions() async {
    PermissionStatus bloothStatus = await Permission.bluetooth.status;
    PermissionStatus locationStatus = await Permission.location.status;

    if (bloothStatus.isDenied &&
        locationStatus.isDenied 
      ) {
      requestPermissions();
    } else {
      requestPermissions();
    }
  }

  

  void requestPermissions() async {
    Map<Permission, PermissionStatus> permissionStatus = await [
      Permission.bluetooth,
      Permission.location
    ].request();

    if (permissionStatus[Permission.bluetooth]!.isGranted &&
        permissionStatus[Permission.location]!.isGranted) {
    } else if (permissionStatus[Permission.bluetooth]!.isDenied &&
        permissionStatus[Permission.location]!.isDenied ) {
    
    } else if (permissionStatus[Permission.bluetooth]!.isPermanentlyDenied &&
        permissionStatus[Permission.location]!.isPermanentlyDenied ) {
      openAppSettings();
    } else {
      return null;
    }
  }


}
