import 'package:flutter/material.dart';

import '../constants/c_colors.dart';

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

vGap(double height) {
  return SizedBox(
    height: height,
  );
}

hGap(double width) {
  return SizedBox(width: width);
}

void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
        child: Text(
      message,
      style: TextStyle(color: pGreenColor),
    )),
    backgroundColor: pLightGreenColor,
  ));
}

void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(child: Text(message, style: TextStyle(color: cRedColor))),
    backgroundColor: cLightRedColor2,
  ));
}

