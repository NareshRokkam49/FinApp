import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Authenticate',
            style: TextStyle(
              color: Colors.white,
            )),
        // centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('How to Authenticate?'),
                    content: const Text(
                        '1. Open the website you want to login to.\n2. Scan the QR code with this app.\n3. Click on the "Continue" button.\n4. Scan your fingerprint to complete the authentication.'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: Colors.black12,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 42,
        height: 42,
        child: FloatingActionButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          onPressed: () async {
            await controller?.toggleFlash();
            setState(() {});
          },
          // ignore: sort_child_properties_last
          child: FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              return Icon(
                  snapshot.data == true ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white);
            },
          ),
          backgroundColor: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 280.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  bool scanned = false;
  bool error = false;

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(result!.code.toString());
        try {
          decodedToken = JwtDecoder.decode(result!.code.toString());
        } catch (e) {
          error = true;
        }
        // if (!scanned) {
        //   scanned = true;
        //   controller.pauseCamera();
        // }
        if (!scanned && decodedToken["issuer"] == "signature") {
          scanned = true;
          controller.pauseCamera();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmation',
                    style: TextStyle(color: Colors.black54)),
                content: RichText(
                  text: TextSpan(
                    text: '\nYou are logging in\n',
                    style:
                        const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    children: <TextSpan>[
                      TextSpan(
                        text: decodedToken["site_name"],
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            letterSpacing: 1.5,
                            wordSpacing: 2,
                            height: 1.5),
                      ),
                      const TextSpan(
                        text: '\n\nDomain: ',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      TextSpan(
                        text: decodedToken["url"],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(
                        text: '\nBrowser:\n',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      TextSpan(
                        text: decodedToken["browser"],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(
                        text: '\nDevice:\n',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      TextSpan(
                        text: decodedToken["platform"],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(
                        text: '\nDate: ',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      TextSpan(
                        text: DateTime.now().toIso8601String().substring(0, 19),
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(
                        text: "\n\nDo you want to authenticate?",
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      controller.resumeCamera();
                      scanned = false;
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          scanned = true;
          controller.pauseCamera();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error!!!',
                      style: TextStyle(color: Colors.red)),
                  content: const Text(
                      'Invalid QR Code. This is not a Signature\'s QR Code.'),
                  actions: [
                    TextButton(
                      child: const Text('Try Again'),
                      onPressed: () {
                        controller.resumeCamera();
                        scanned = false;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      });
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}