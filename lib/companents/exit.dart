import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/c_colors.dart';
import '../../../utils/display_utils.dart';
import '../resources/text_styles.dart';

willpopAlert(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(50),
        buttonPadding: EdgeInsets.all(50),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text('Are you sure you want to exit?',style: TextStyles.getSubTita14(),),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity(),
                  shape: StadiumBorder(),
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: cPrimeryColor),
                ),
              ),
              hGap(10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    disabledForegroundColor: cPrimeryColor),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: cPrimeryColor,
                  ),
                ),
              )
            ],
          )
        ],
      );
    },
  );
}
