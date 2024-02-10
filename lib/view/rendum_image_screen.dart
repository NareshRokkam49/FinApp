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
import 'package:provider/provider.dart';

class RendomImageScreen extends StatelessWidget {
  RendomImageScreen({Key? key});
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
                        bluetoothBtn()
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

  Widget bluetoothBtn() {
    return ValueListenableBuilder(
        valueListenable: _bluetoothValue,
        builder: (context, value, child) {
          return Column(
            children: [
              CButton(
                  color: Colors.transparent,
                  onPressed: () {
                    enableBluetooth(context);
                  },
                  text: Text("Bluetooth")),
            ],
          );
        });
  }

  Future<void> enableBluetooth(BuildContext context) async {
    try {
      await _bluetoothChannel.invokeMethod('enableBluetooth');
    } on PlatformException catch (e) {
      if (e.code == 'bluetooth_off') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Bluetooth is Off'),
            content: Text('Please enable Bluetooth manually and try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
