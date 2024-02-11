import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task/companents/c_buttons.dart';
import 'package:flutter_task/companents/exit.dart';
import 'package:flutter_task/constants/c_colors.dart';
import 'package:flutter_task/constants/c_strings.dart';
import 'package:flutter_task/constants/imageConstants.dart';
import 'package:flutter_task/resources/text_styles.dart';
import 'package:flutter_task/routes/app_routes.dart';
import 'package:flutter_task/utils/display_utils.dart';
import 'package:get/get.dart' hide Response;
import 'package:permission_handler/permission_handler.dart';
import '../modals/res/rendom_dog_res.dart';
import '../modals/services/api_endpoint.dart';

class RendomImageScreen extends StatefulWidget {
  RendomImageScreen({Key? key});

  @override
  State<RendomImageScreen> createState() => _RendomImageScreenState();
}

class _RendomImageScreenState extends State<RendomImageScreen> {
  static const MethodChannel _channel = MethodChannel('bluetooth_channel');
  RendomDogRes? _rendomDogRes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cLightVoiletColor,
        title: Text(
          CStrings.rendomDog,
          style: TextStyles.getSubTital20(),
        ),
        centerTitle: true,
        actions: [
          _profileWidget(),
          hGap(5),
        ],
      ),
      body: WillPopScope(
        onWillPop: () => willpopAlert(context),
        child: Center(
          child: _rendomDogRes == null
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        refreshBtn(_rendomDogRes),
                        vGap(30),
                        rendomImage(_rendomDogRes),
                        vGap(20),
                        bluetoothBtn(_rendomDogRes),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _profileWidget() {
    return Tooltip(
      message: CStrings.profile,
      child: CButton(
          height: 70,
          color: Colors.transparent,
          borderColor: Colors.transparent,
          onPressed: () {
            Get.toNamed(AppRoutes.profileScreen);
          },
          text: CircleAvatar(
            backgroundColor: CWhiteColor,
            child: Icon(Icons.person),
          )),
    );
  }

  Widget rendomImage(RendomDogRes? rendomDogRes) {
    return rendomDogRes!.message!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: rendomDogRes.message ?? "",
            errorWidget: (context, url, error) {
              return Column(
                children: [
                  Icon(Icons.error, color: cRedColor, size: 50),
                  vGap(10),
                  Text(
                    "Image error occurred",
                    style: TextStyles.getSubTital18(textColor: cRedColor),
                  )
                ],
              );
            },
            imageBuilder: (context, imageProvider) {
              // ignore: unnecessary_null_comparison
              if (imageProvider != null) {
                return Image(image: imageProvider);
              } else {
                return CircularProgressIndicator(color: cGreenColor);
              }
            },
          )
        : CircularProgressIndicator(color: cGreenColor);
  }

  Widget refreshBtn(RendomDogRes? rendomDogRes) {
    return rendomDogRes!.message != null
        ? CButton(
            borderColor: Colors.transparent,
            color: Colors.transparent,
            onPressed: () async {
              await dataFromTheRendomDogImageApi();
            },
            text: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Refresh"),
                hGap(10),
                Image.asset(
                  ImageConstants.refreshIconPng,
                  color: cBlackColor,
                  height: 20,
                )
              ],
            ),
          )
        : Container();
  }

  static Future<void> enableBluetooth() async {
    try {
      await _channel.invokeMethod('enableBluetooth');
    } on PlatformException catch (e) {
      print('Failed to enable Bluetooth: ${e.message}');
    }
  }

  Widget bluetoothBtn(RendomDogRes? rendomDogRes) {
    return CButton(
        color: Colors.transparent,
        onPressed: () async {
          enableBluetooth();
        },
        text: Text("Bluetooth"));
  }

  Future<void> checkPermissions() async {
    PermissionStatus bluetoothStatus = await Permission.bluetooth.status;
    PermissionStatus locationStatus = await Permission.location.status;

    if (bluetoothStatus.isDenied || locationStatus.isDenied) {
      setState(() {
        requestPermissions();
      });
    } else {
      setState(() {
        requestPermissions();
      });
    }
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> permissionStatus = await [
      Permission.bluetooth,
      Permission.location,
    ].request();
    if (permissionStatus[Permission.bluetooth]!.isGranted ||
        permissionStatus[Permission.location]!.isGranted) {
    } else if (permissionStatus[Permission.bluetooth]!.isDenied ||
        permissionStatus[Permission.location]!.isDenied) {
      openAppSettings();
    } else if (permissionStatus[Permission.bluetooth]!.isPermanentlyDenied ||
        permissionStatus[Permission.location]!.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> dataFromTheRendomDogImageApi() async {
    try {
      Response rendomResponce = await Dio().get(
        ApiEndPoint.rendomApi,
      );
      final rendomresult = RendomDogRes.fromJson(rendomResponce.data);
      setState(() {
        _rendomDogRes = rendomresult;
      });
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    dataFromTheRendomDogImageApi();
    checkPermissions();
    super.initState();
  }
}
