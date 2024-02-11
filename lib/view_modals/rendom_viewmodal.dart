import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../modals/res/rendom_dog_res.dart';
import '../modals/services/api_endpoint.dart';

class RendomViewModal with ChangeNotifier {
  RendomDogRes? rendomDogRes;
  RendomViewModal() {
    initializeData();
  }
  Future<void> initializeData() async {
    checkPermissions();
    await dataFromTheRendomDogImageApi();
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

  Future<void> checkPermissions() async {
    print("checkPermissions");
    PermissionStatus bluetoothStatus = await Permission.bluetooth.status;
    PermissionStatus locationStatus = await Permission.location.status;

    if (bluetoothStatus.isDenied ||locationStatus.isDenied) {
      print(await Permission.bluetooth.status);
      print(await Permission.location.status);
      requestPermissions();
    } else {
      print("else${bluetoothStatus}");

      // Permissions are not granted, you can request them.
      requestPermissions();
    }
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> permissionStatus = await [
      Permission.bluetooth,
      Permission.location,
    ].request();
    if (permissionStatus[Permission.bluetooth]!.isGranted  ||
        permissionStatus[Permission.location]!.isGranted) {
    } else if (permissionStatus[Permission.bluetooth]!.isDenied  ||
        permissionStatus[Permission.location]!.isDenied) {
      print("bluetoot   hStatus${permissionStatus}");

      // Permissions are denied or permanently denied.
      // You can show an error message or guide the user to enable permissions in settings.
      openAppSettings();
    } else if (permissionStatus[Permission.bluetooth]!.isPermanentlyDenied  ||
        permissionStatus[Permission.location]!.isPermanentlyDenied) {
      print("   hStatus${permissionStatus}");

      openAppSettings();
    }
  }
}
