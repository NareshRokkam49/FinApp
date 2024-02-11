import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:flutter_task/view_modals/rendom_viewmodal.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class RendomImageScreen extends StatefulWidget {
  RendomImageScreen({Key? key});

  @override
  State<RendomImageScreen> createState() => _RendomImageScreenState();
}

class _RendomImageScreenState extends State<RendomImageScreen> {
  final ValueNotifier _bluetoothValue = ValueNotifier(false);

  final MethodChannel _bluetoothChannel = MethodChannel('bluetooth_channel');

  @override
  Widget build(BuildContext context) {
    final randomViewModel = Provider.of<RendomViewModal>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cLightVoiletColor,
        title: Text(
          CStrings.rendomDog,
          style: TextStyles.getSubTital20(),
        ),
        centerTitle: true,
        actions: [
          _profile(),
          hGap(5),
        ],
      ),
      body: WillPopScope(
        onWillPop: () => willpopAlert(context),
        child: Center(
          child: randomViewModel.rendomDogRes == null
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        refreshBtn(randomViewModel),
                        vGap(30),
                        rendomImage(randomViewModel),
                        vGap(20),
                        bluetoothBtn(randomViewModel),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _profile() {
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

  Widget rendomImage(RendomViewModal randomViewModel) {
    return randomViewModel.rendomDogRes!.message!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: randomViewModel.rendomDogRes!.message ?? "",
            imageBuilder: (context, imageProvider) {
              // ignore: unnecessary_null_comparison
              if (imageProvider != null) {
                return Image(image: imageProvider);
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        : CircularProgressIndicator(color: cSkyBuleColor);
  }

  Widget refreshBtn(RendomViewModal randomViewModel) {
    return randomViewModel.rendomDogRes!.message != null
        ? CButton(
            borderColor: Colors.transparent,
            color: Colors.transparent,
            onPressed: () {
              randomViewModel.dataFromTheRendomDogImageApi();
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

  Widget bluetoothBtn(RendomViewModal randomViewModel) {
    return CButton(
        color: Colors.transparent,
        onPressed: () async {
          await enableBluetooth();
        },
        text: Text("Bluetooth"));
  }
  Future<void> enableBluetooth() async {
    try {
      final bool result = await _bluetoothChannel.invokeMethod('enableBluetooth');
      print('Bluetooth enabled: $result');
    } on PlatformException catch (e) {
      print('Failed to enable Bluetooth: ${e.message}');
    }
  }

  
  @override
  void initState() {
    requestBluetoothPermissions(context);
    print("object");
    super.initState();
  }

  void requestBluetoothPermissions(BuildContext context) async {
    PermissionStatus status = await Permission.bluetooth.request();
    if (status.isGranted) {
      // Permissions are granted, you can proceed with Bluetooth functionality.
      print('Bluetooth permissions granted');
    } else if (status.isDenied) {
      // Permissions are denied.
      print('Bluetooth permissions denied');
    } else if (status.isPermanentlyDenied) {
      // Permissions are permanently denied, user has to go to settings to enable them.
      openAppSettings();
    }
  }
}
