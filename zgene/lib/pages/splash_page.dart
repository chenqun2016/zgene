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
  bool isFirst = true;
  var container = TabNavigator();
  bool showSplash = true;
  bool showSkip = false;

  CountDownWidget _countDownWidget;
  @override
  void initState() {
    super.initState();
    //倒计时控件
    _countDownWidget = CountDownWidget(
      onCountDownFinishCallBack:(bool value) {
        if (value) {
          setState(() {
            showSplash = false;
          });
        }
      },
    );
    isFirst = SpUtils().getStorageDefault(SpConstant.SpIsFirst, true);
    //第一次启动app
    if (isFirst) {
      WidgetsBinding.instance.addPostFrameCallback((callback) {
        ///显示协议弹窗
        UiUitls.showAgreement(context, onAgree: () {
          SpUtils().setStorage(SpConstant.SpIsFirst, false);
          isFirst = false;
          showSkip = true;
          setState(() {});
        }, onCancel: () {
          exit(0);
        });
      });
    } else {
      showSkip = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    print('build splash');
    return Stack(
      children: <Widget>[
        Offstage(
          child: container,
          offstage: showSplash,
        ),
        Offstage(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(0.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: ScreenUtils.screenW(context) / 3,
                        backgroundColor: Colors.white,
                        backgroundImage:
                        AssetImage('assets/images/home.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          '落花有意随流水,流水无心恋落花',
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
                SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        showSkip?Align(
                          alignment: Alignment(1.0, 0.0),
                          child: GestureDetector(child: Container(
                            margin: const EdgeInsets.only(
                                right: 30.0, top: 20.0),
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                            child: _countDownWidget,
                            decoration: BoxDecoration(
                                color: Color(0xffEDEDED),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                          ),
                          onTap: (){
                            _countDownWidget.isSkip = true;
                          },),
                        ):Text(""),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/ic_launcher.png',
                                width: 50.0,
                                height: 50.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Hi,豆芽',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
            width: ScreenUtils.screenW(context),
            height: ScreenUtils.screenH(context),
          ),
          offstage: !showSplash,
        )
      ],
    );
  }
}
