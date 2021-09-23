import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/my_qr_scanner_overlay_shape.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample>
    with SingleTickerProviderStateMixin {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  double cutOutTopOffset = 200;
  var _image;
  double scanArea = 0;
  Animation<double> animation;
  AnimationController animationController;

  @override
  void dispose() {
    controller?.dispose();
    animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    try {
      UiUitls.loadImageFromAssets("assets/images/mine/img_saomiao.png")
          .then((value) => setState(() {
                _image = value;
                print("_image == " + _image.toString());
              }));
    } catch (e) {
      print("_image == " + e.toString());
    }

    animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
      scanArea = (MediaQuery.of(context).size.width < 400 ||
              MediaQuery.of(context).size.height < 400)
          ? 300.0
          : 500.0;
      print("animation scanArea == " + scanArea.toString());
      animation = Tween(begin: 0.0, end: scanArea).animate(animationController)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            //动画执行结束时反向执行动画
            animationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            //动画恢复到初始状态时执行动画（正向）
            animationController.forward();
          }
        });
      //启动动画
      animationController.forward();
    });
  }

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
        alignment: Alignment.topCenter,
        children: [
          _buildQrView(context),
          Container(
            width: double.infinity,
            height: 44,
            margin: EdgeInsets.only(left: 20, top: 38, right: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(left: 0, child: customHeaderBack()),
                Positioned(right: 0, child: _buildGallery()),
                buildTitle(),
              ],
            ),
          ),
          if (null != animation) _buildLine(),
          buildBottom()
        ],
      ),
    );
  }

  buildBottom() {
    return Container(
      margin: EdgeInsets.only(top: cutOutTopOffset + scanArea),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "将二维码/条形码放入框内，即可自动扫描",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white70),
          ),
          Divider(
            height: 55,
          ),
          _buildLight(),
          Expanded(
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/mine/icon_shuru.png",
                height: 20,
                width: 20,
              ),
              Text(
                "手动输入采集器编号",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              Image.asset(
                "assets/images/mine/icon_back_white.png",
                height: 20,
                width: 20,
              ),
            ],
          ),
          Divider(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(28),
            child: Text(
              "联系客服",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Text buildTitle() {
    return Text(
      "扫码绑定",
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }

  _buildLight() {
    return GestureDetector(
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
          // return Icon(
          //   Icons.flash_on,
          //   color: snapshot.data == null
          //       ? Colors.white
          //       : (snapshot.data ? Colors.blue : Colors.white),
          //   size: 25,
          // );
          return Image.asset(
            "assets/images/mine/icon_light.png",
            height: 48,
            width: 48,
          );
        },
      ),
    );
  }

  _buildGallery() {
    return GestureDetector(
      onTap: () async {
        try {
          final picker = ImagePicker();
          var image = await picker.getImage(
            source: ImageSource.gallery,
          );
          print("image.path == " + image.path);

          String result = await Scan.parse(image.path);
          print("image.path.result == " + result.toString());
        } catch (e) {
          print("image.path.result.err == " + e.toString());
        }
      },
      child: Text(
        "相册",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  AnimatedBuilder _buildLine() {
    return AnimatedBuilder(
      animation: animation,
      child: Image.asset(
        "assets/images/mine/img_saomaxian.png",
        height: 2,
        width: 278,
      ),
      builder: (BuildContext ctx, child) {
        return Container(
          margin: EdgeInsets.only(
              top: cutOutTopOffset +
                  4 +
                  (animation.value > (scanArea - 8)
                      ? (scanArea - 8)
                      : animation.value)),
          child: child,
        );
      },
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
            height: 40,
            width: 40,
            fit: BoxFit.fill,
          )),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: MyQrScannerOverlayShape(
          image: _image,
          cutOutTopOffset: cutOutTopOffset,
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 10,
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
      print(
          "scan code == ${scanData.code} / type == ${scanData.format.toString()}");
      Navigator.pop(context, scanData.code);
    }).catchError((error) => null);
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(UiUitls.showToast("请打开相机权限"));
    }
  }
}
