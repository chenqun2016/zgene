import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/navigator/tab_navigator.dart';
import 'package:zgene/util/screen_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/count_down_widget.dart';

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
        UiUitls.showAgreement2(context, onAgree: () {
          SpUtils().setStorage(SpConstant.SpIsFirst, false);
          isFirst = false;
          setState(() {});
        }, onCancel: () {
          exit(0);
        });
      });
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
}
