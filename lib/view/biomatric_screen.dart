import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../companents/c_buttons.dart';
import '../routes/app_routes.dart';
import '../utils/display_utils.dart';

class BioMatricScreen extends StatefulWidget {
  const BioMatricScreen({Key? key}) : super(key: key);

  @override
  State<BioMatricScreen> createState() => _BioMatricScreenState();
}

class _BioMatricScreenState extends State<BioMatricScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final ValueNotifier isAvailable = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    checkBiometrics();
  }

  Future<void> checkBiometrics() async {
    try {
      isAvailable.value = await auth.canCheckBiometrics;
    
    } catch (e) {
      print('Error checking biometrics: $e');
    }
  }

  Future<void> biomatricAuthenticate() async {
    try {
      if (isAvailable.value) {
        bool authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to proceed',
        );
        print("authenticated>>>>>>>...$authenticated");
        if (authenticated) {
          Get.toNamed(AppRoutes.qRScanner);
        } else {
          print('Authentication denied');
        }
      } else {
        print('Biometric authentication not available');
      }
    } catch (e) {
      print('Error authenticating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text('Biometric Authentication'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ValueListenableBuilder(
              valueListenable: isAvailable,
              builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isAvailable.value)
                      CButton(
                        width: getWidth(context),
                        onPressed: biomatricAuthenticate,
                        text: const Text('Authenticate'),
                      ),
                    if (!isAvailable.value)
                      Text('Biometric authentication not available'),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
