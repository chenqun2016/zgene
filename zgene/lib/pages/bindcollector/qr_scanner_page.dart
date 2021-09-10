import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/util/platform_utils.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (PlatformUtils.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildQrView(context),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, top: 38, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customHeaderBack(),
                Expanded(child: Divider()),
                GestureDetector(
                  onTap: () async {
                    if (null != controller) {
                      await controller.toggleFlash();
                      setState(() {});
                    }
                  },
                  child: FutureBuilder(
                    future: controller != null
                        ? controller.getFlashStatus()
                        : Future.value(false),
                    builder: (context, snapshot) {
                      return Icon(
                        Icons.flash_on,
                        color: snapshot.data == null
                            ? Colors.white
                            : (snapshot.data ? Colors.blue : Colors.white),
                        size: 25,
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 配置页面头部返回
  Widget customHeaderBack() {
    return Container(
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            image: AssetImage("assets/images/icon_base_backArrow.png"),
            // height: 40.w,
            // width: 40.w,
            fit: BoxFit.fill,
          )),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.first.then((scanData) {
      Navigator.pop(context, scanData.code);
    }).catchError((error) => null);
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(UiUitls.showToast("请打开相机权限"));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
