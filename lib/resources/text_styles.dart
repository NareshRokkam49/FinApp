import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/c_colors.dart';

class TextStyles {
  static getSubTital18({
    double? fontSize,
    FontWeight? fontWeight,
    Color? textColor,
  }) {
    return getBaseStyle(
      fontSize ?? 18,
      fontWeight ?? FontWeight.w500,
      textColor ?? cPrimeryColor2,
    );
  }

 


  static getSubTita14(
      {double? fontSize,
      FontWeight? fontWeight,
      Color? textColor,
      String? fontFamily}) {
    return getBaseStyle(fontSize ?? 14, fontWeight ?? FontWeight.w600,
        textColor ?? cBlackColor);
  }


 static getSubTital20({
    double? fontSize,
    FontWeight? fontWeight,
    Color? textColor,
  }) {
    return getBaseStyle(
      fontSize ?? 20,
      fontWeight ?? FontWeight.w700,
      textColor ?? cPrimeryColor,
    );
  }

 

 static TextStyle getBaseStyle(
    double fontSize,
    FontWeight fontWeight,
    Color color,
  ) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}