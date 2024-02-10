import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import '../modals/res/rendom_dog_res.dart';
import '../modals/services/api_endpoint.dart';

class RendomViewModal with ChangeNotifier {

  RendomDogRes? rendomDogRes;
  RendomViewModal() {
    dataFromTheRendomDogImageApi();
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
}
