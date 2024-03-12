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
import 'package:get/get.dart' hide Response;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../modals/res/rendom_dog_res.dart';

class RendomImageScreen extends StatelessWidget {
  const RendomImageScreen({super.key});
  static const MethodChannel _channel = MethodChannel('bluetooth_channel');

  @override
  Widget build(BuildContext context) {
        final rendomDogRes = Provider.of<RendomViewModal>(context);

    return  Scaffold(
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
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (!didPop) {
            willpopAlert(context);
          } else {
            return null;
          }
        },
        child: Center(
          child: rendomDogRes.rendomDogRes == null
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        refreshBtn(rendomDogRes),
                        vGap(30),
                        rendomImage(rendomDogRes.rendomDogRes),
                        vGap(20),
                        bluetoothBtn(rendomDogRes.rendomDogRes),
                        vGap(20),
                        // CButton(
                        //     onPressed: () {
                        //       Get.toNamed(AppRoutes.bioMatricScreen);
                        //     },
                        //     text: Text("biomatric")),
                        // vGap(20),
                        // CButton(
                        //     onPressed: () {
                        //       Get.toNamed(AppRoutes.qRScanner);
                        //     },
                        //     text: Text("qrcode")),
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

  Widget refreshBtn(RendomViewModal rendomDogRes) {
    return rendomDogRes.rendomDogRes!.message != null
        ? CButton(
            borderColor: Colors.transparent,
            color: Colors.transparent,
            onPressed: () async {
              await rendomDogRes.dataFromTheRendomDogImageApi();
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
        onPressed: handleBluetoothActions,
        text: Text("Bluetooth"));
  }

  void handleBluetoothActions() async {
    await checkAndRequestBluetoothPermission();
    await enableBluetooth();
  }

  Future<void> checkAndRequestBluetoothPermission() async {
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
  }
}
// class RendomImageScreen extends StatefulWidget {
//   RendomImageScreen({Key? key});

//   @override
//   State<RendomImageScreen> createState() => _RendomImageScreenState();
// }

// class _RendomImageScreenState extends State<RendomImageScreen> {
//   static const MethodChannel _channel = MethodChannel('bluetooth_channel');
//   @override
//   Widget build(BuildContext context) {
//     final rendomDogRes = Provider.of<RendomViewModal>(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: cLightVoiletColor,
//         title: Text(
//           CStrings.rendomDog,
//           style: TextStyles.getSubTital20(),
//         ),
//         centerTitle: true,
//         actions: [
//           _profileWidget(),
//           hGap(5),
//         ],
//       ),
//       body: PopScope(
//         canPop: false,
//         onPopInvoked: (bool didPop) {
//           if (!didPop) {
//             willpopAlert(context);
//           } else {
//             return null;
//           }
//         },
//         child: Center(
//           child: rendomDogRes.rendomDogRes == null
//               ? CircularProgressIndicator()
//               : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         refreshBtn(rendomDogRes),
//                         vGap(30),
//                         rendomImage(rendomDogRes.rendomDogRes),
//                         vGap(20),
//                         bluetoothBtn(rendomDogRes.rendomDogRes),
//                         vGap(20),
//                         CButton(
//                             onPressed: () {
//                               Get.toNamed(AppRoutes.bioMatricScreen);
//                             },
//                             text: Text("biomatric")),
//                         vGap(20),
//                         CButton(
//                             onPressed: () {
//                               Get.toNamed(AppRoutes.qRScanner);
//                             },
//                             text: Text("qrcode")),
//                       ],
//                     ),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _profileWidget() {
//     return Tooltip(
//       message: CStrings.profile,
//       child: CButton(
//           height: 70,
//           color: Colors.transparent,
//           borderColor: Colors.transparent,
//           onPressed: () {
//             Get.toNamed(AppRoutes.profileScreen);
//           },
//           text: CircleAvatar(
//             backgroundColor: CWhiteColor,
//             child: Icon(Icons.person),
//           )),
//     );
//   }

//   Widget rendomImage(RendomDogRes? rendomDogRes) {
//     return rendomDogRes!.message!.isNotEmpty
//         ? CachedNetworkImage(
//             imageUrl: rendomDogRes.message ?? "",
//             errorWidget: (context, url, error) {
//               return Column(
//                 children: [
//                   Icon(Icons.error, color: cRedColor, size: 50),
//                   vGap(10),
//                   Text(
//                     "Image error occurred",
//                     style: TextStyles.getSubTital18(textColor: cRedColor),
//                   )
//                 ],
//               );
//             },
//             imageBuilder: (context, imageProvider) {
//               // ignore: unnecessary_null_comparison
//               if (imageProvider != null) {
//                 return Image(image: imageProvider);
//               } else {
//                 return CircularProgressIndicator(color: cGreenColor);
//               }
//             },
//           )
//         : CircularProgressIndicator(color: cGreenColor);
//   }

//   Widget refreshBtn(RendomViewModal rendomDogRes) {
//     return rendomDogRes.rendomDogRes!.message != null
//         ? CButton(
//             borderColor: Colors.transparent,
//             color: Colors.transparent,
//             onPressed: () async {
//               await rendomDogRes.dataFromTheRendomDogImageApi();
//             },
//             text: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Refresh"),
//                 hGap(10),
//                 Image.asset(
//                   ImageConstants.refreshIconPng,
//                   color: cBlackColor,
//                   height: 20,
//                 )
//               ],
//             ),
//           )
//         : Container();
//   }

//   static Future<void> enableBluetooth() async {
//     try {
//       await _channel.invokeMethod('enableBluetooth');
//     } on PlatformException catch (e) {
//       print('Failed to enable Bluetooth: ${e.message}');
//     }
//   }

//   Widget bluetoothBtn(RendomDogRes? rendomDogRes) {
//     return CButton(
//         color: Colors.transparent,
//         onPressed: handleBluetoothActions,
//         text: Text("Bluetooth"));
//   }

//   void handleBluetoothActions() async {
//     await checkAndRequestBluetoothPermission();
//     await enableBluetooth();
//   }

//   Future<void> checkAndRequestBluetoothPermission() async {
//     if (await Permission.bluetoothConnect.isDenied) {
//       await Permission.bluetoothConnect.request();
//     }
//   }
// }
