import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/navigator/tab_navigator.dart';
import 'package:zgene/util/screen_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

///打开APP首页
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var spUtils = SpUtils();
  bool isFirst = true;

  var container = TabNavigator();
  bool showAd = true;

  _initSDK() {}

  @override
  void initState() {
    super.initState();
    isFirst = spUtils.getStorageDefault(SpConstant.SpIsFirst, true);
    if (isFirst) {
      WidgetsBinding.instance!.addPostFrameCallback((callback) {
        UiUitls.showAgreement(context, onAgree: () {
          spUtils.setStorage(SpConstant.SpIsFirst, false);
          isFirst = false;
          //初始化基础库.
          _initSDK();
        }, onCancel: () {
          exit(0);
        });
      });
    } else {
      _initSDK();
    }
  }


  @override
  Widget build(BuildContext context) {
    print('build splash');
    return Stack(
      children: <Widget>[
        Offstage(
          child: container,
          offstage: showAd,
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
                        Align(
                          alignment: Alignment(1.0, 0.0),
                          child: Container(
                            margin: const EdgeInsets.only(right: 30.0, top: 20.0),
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                            child: CountDownWidget(
                              onCountDownFinishCallBack: (bool value) {
                                if (value) {
                                  setState(() {
                                    showAd = false;
                                  });
                                }
                              },
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xffEDEDED),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                          ),
                        ),
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
          offstage: !showAd,
        )
      ],
    );
  }
}

class CountDownWidget extends StatefulWidget {
  final onCountDownFinishCallBack;

  CountDownWidget({Key? key, @required this.onCountDownFinishCallBack})
      : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  var _seconds = 6;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_seconds',
      style: TextStyle(fontSize: 17.0),
    );
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
      if (_seconds <= 1) {
        widget.onCountDownFinishCallBack(true);
        _cancelTimer();
        return;
      }
      _seconds--;
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }
}
