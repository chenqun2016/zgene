import 'dart:io';

import 'package:base/util/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/navigator/tab_navigator.dart';
import 'package:zgene/util/agreement_utils.dart';
import 'package:zgene/util/screen_utils.dart';
import 'package:zgene/util/umeng_utils.dart';

///app启动页
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isFirst = false;
  var container = TabNavigator();
  bool showSplash = false;

  @override
  void initState() {
    super.initState();
    isFirst = SpUtils().getStorageDefault(SpConstant.SpIsFirst, true);
    //第一次启动app
    if (isFirst) {
      WidgetsBinding.instance.addPostFrameCallback((callback) {
        ///显示协议弹窗
        AgreementUtils.showAgreement2(context, onAgree: () {
          initOther();
          SpUtils().setStorage(SpConstant.SpIsFirst, false);
          isFirst = false;
          setState(() {});
        }, onCancel: () {
          exit(0);
        });
      });
    } else {
      initOther();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build splash');
    return Stack(
      children: <Widget>[
        Offstage(
          child: isFirst ? Text("") : container,
          offstage: showSplash,
        ),
        Offstage(
          child: Image.asset(
            "assets/images/splash.png",
            height: ScreenUtils.screenH(context),
            width: ScreenUtils.screenW(context),
          ),
          offstage: !showSplash,
        )
      ],
    );
  }

  void initOther() {
    UmengUtils.initCommon();
  }
}
