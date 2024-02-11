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

  dataFromTheRendomDogImageApi() async {
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
    PermissionStatus bluetoothStatus = await Permission.bluetooth.status;
    if (bluetoothStatus.isDenied) {
      // Permissions are already granted, proceed with log-related functionality.
      requestPermissions();
    } else {
      // Permissions are not granted, you can request them.
      requestPermissions();
    }
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> permissionStatus = await [
      Permission.bluetooth,
    ].request();
    if (permissionStatus[Permission.bluetooth]!.isGranted) {
    } else if (permissionStatus[Permission.bluetooth]!.isDenied) {
      // Permissions are denied or permanently denied.
      // You can show an error message or guide the user to enable permissions in settings.
      openAppSettings();
    } else if (permissionStatus[Permission.bluetooth]!.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
