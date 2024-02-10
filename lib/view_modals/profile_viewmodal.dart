import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_task/modals/res/profile_res.dart';
import '../modals/services/api_endpoint.dart';

class ProfileViewModal with ChangeNotifier {
ProfileRes? profileList;
  ProfileViewModal() {
    dataFromProfileApi();
  }

  dataFromProfileApi() async {
    try {
      Response profileResponce = await Dio().get(
        ApiEndPoint.profileApi,
      );
      final profileResult = ProfileRes.fromJson(profileResponce.data);
      profileList = profileResult;
      notifyListeners();
    
    } on DioException catch (e) {
      print(e);
    }
  }
}
