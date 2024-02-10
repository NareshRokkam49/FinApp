import 'package:flutter/material.dart';

import '../constants/c_colors.dart';
import '../utils/display_utils.dart';

class CLoader extends StatelessWidget {
  final Color? loaderColor;
  final double? size;
  final bool? loader;

  CLoader({this.loaderColor, this.size, this.loader});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: size ?? 25,
          height: size ?? 25,
          child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: loaderColor ?? cPrimeryColor,
                    ),
                  ),
                  hGap(10),
                  Text(
                    "Loading...",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: loaderColor ?? cPrimeryColor),
                  )
                ],
              )
            ],
          )),
    );
  }
}
