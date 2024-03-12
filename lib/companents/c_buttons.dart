import 'package:flutter/cupertino.dart';
import 'package:flutter_task/companents/c_loader.dart';
import 'package:flutter_task/constants/c_colors.dart';



class CButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget text;
  final double? width;
  final double? height;
  final TextStyle? style;
  final Color? color;
  final Color? textColor;
  final Color? loadingColor;
  final EdgeInsets? contentPadding;
  final Color? borderColor;
  final double? borderRadius;
  final bool? loadingView;

  CButton({
    Key? key,
    this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.color,
    this.style,
    this.loadingColor,
    this.textColor,
    this.loadingView,
    this.contentPadding,
    this.borderColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          border: Border.all(color: borderColor ?? cPrimeryColor),
          color: onPressed != null
              ? (color ?? (borderColor ?? cPrimeryColor))
              : null),
      width: width,
      height: height == null ? 45 : height,
      child: CupertinoButton(
        minSize: 45,
        pressedOpacity: .1,
        padding: EdgeInsets.all(0),
        onPressed: (loadingView ?? false) ? () {} : onPressed,
        child: Padding(
          padding: contentPadding ?? const EdgeInsets.all(8.0),
          child: (loadingView ?? false)
              ? Center(
                  child: CLoader(
                    loaderColor: loadingColor ?? CWhiteColor,
                    size: 24,
                  ),
                )
              : text,
        ),
      ),
    );
  }
}
