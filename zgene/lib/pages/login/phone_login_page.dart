

import 'dart:async';
import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/event/event_bus.dart';
import 'package:zgene/event/event_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/widget/base_web.dart';

import 'account_login_page.dart';

////手机号登录
// ignore: camel_case_types
class phoneLoginPage extends StatefulWidget {
  phoneLoginPage({Key key}) : super(key: key);

  @override
  _phoneLoginPageState createState() => _phoneLoginPageState();
}

class _phoneLoginPageState extends State<phoneLoginPage> {
  bool _isAvailableGetVCode = true; //是否可以获取验证码，默认为`false`
  String _verifyStr = '发送验证码';

  String _phoneErrorStr = null;
  String _verifyErrorStr = null;

  String _phoneText = "";
  String _verifyText = "";

  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  /// 倒计时的秒数，默认60秒。
  final int countdown = 60;

  void initState() {
    // TODO: implement initState
    super.initState();
    _seconds = countdown;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorConstant.WhiteColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  top: 53,
                ),
                width: 32,
                height: 16,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    // NavigatorUtils.goBack(context);
                    Navigator.pop(context);
                  },
                  icon: ImageIcon(
                    AssetImage("assets/images/mine/icon_mine_backArrow.png"),
                    size: 16,
                    color: ColorConstant.MainBlack,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 36,
                  left: 33,
                ),
                child: Text(
                  "手机号登录",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextMainColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 3,
                  left: 33,
                ),
                child: RichText(
                    text: TextSpan(
                        text: "请点击阅读",
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.TextSecondColor,
                        ),
                        children: [
                          TextSpan(
                              text: "用户协议",
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.TextMainColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  NavigatorUtil.push(context,  BaseWebView(
                                    url: ApiConstant.agreements,
                                    title: "用户协议",
                                  ));
                                }),
                          TextSpan(
                              text: "和",
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.TextSecondColor,
                              )),
                          TextSpan(
                              text: "隐私政策",
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.TextMainColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  NavigatorUtil.push(context,  BaseWebView(
                                    url: ApiConstant.privacys,
                                    title: "隐私政策",
                                  ));
                                }),
                        ])),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 67,
                  left: 33,
                  right: 33,
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _phoneText = value;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    //只允许输入字母
                  ],
                  decoration: InputDecoration(
                    labelText: "手机号",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                    errorText: _phoneErrorStr,
                    enabledBorder: new UnderlineInputBorder(
                      // 不是焦点的时候颜色
                      borderSide:
                      BorderSide(color: ColorConstant.LineMainColor),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.TextSecondColor,
                    ),
                    prefixText: "+86 ：",
                    prefixStyle: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.TextMainColor,
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 5,
                      left: 33,
                      right: 33,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _verifyText = value;
                      },
                      decoration: InputDecoration(
                        labelText: "请输入验证码",
                        enabledBorder: new UnderlineInputBorder(
                          // 不是焦点的时候颜色
                          borderSide:
                          BorderSide(color: ColorConstant.LineMainColor),
                        ),
                        errorText: _verifyErrorStr,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.TextSecondColor,
                        ),
                      ),
                      inputFormatters: [LengthLimitingTextInputFormatter(6)],
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 33,
                      child: Container(
                        child: TextButton(
                            onPressed: _seconds == countdown
                                ? () {
                              getVerifyCode();
                              //获取验证码
                            }
                                : null,
                            child: Center(
                              child: Text(
                                _verifyStr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  color: Color(CommonConstant.THEME_COLOR),
                                ),
                              ),
                            )),
                      ))
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: 35, left: 33),
                  height: 45,
                  width: MediaQuery.of(context).size.width - 66,
                  child: TextButton(
                    onPressed: () {
                      loginBtnAction();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0)),
                        ),
                        backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                          return Color(CommonConstant.THEME_COLOR);
                        })),
                    child: Text(
                      "立即登录",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.WhiteColor),
                    ),
                  )),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextButton(
                      onPressed: () {
                        changeToAccountLogin();
                      },
                      child: Center(
                        child: Text(
                          '账号密码登录',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: Color(CommonConstant.THEME_COLOR),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//获取验证码
  void getVerifyCode() {
    if (_phoneText == "") {
      _phoneErrorStr = "请输入手机号";
      setState(() {});
      return;
    } else {
      setState(() {});
      _phoneErrorStr = null;
    }

    Map<String, dynamic> map = new HashMap();
    map["mobile"] = _phoneText;

    EasyLoading.show(status: 'loading...');

    HttpUtils.requestHttp(
      ApiConstant.loginSms,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) {
        print(data.toString());
        EasyLoading.dismiss();
        _startTimer();
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
      },
    );
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      _isAvailableGetVCode = false;
      _verifyStr = '已发送(${_seconds}s)';
      if (_seconds == 0) {
        _verifyStr = '重新获取';
        _isAvailableGetVCode = true;
        _seconds = countdown;
        _cancelTimer();
      }
      setState(() {});
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cancelTimer();
    _timer = null;
    super.dispose();
  }

  void loginBtnAction() {
    if (_phoneText == "") {
      _phoneErrorStr = "请输入手机号";
    } else {
      _phoneErrorStr = null;
    }
    if (_verifyText == "") {
      _verifyErrorStr = "请输入验证码";
    } else {
      _verifyErrorStr = null;
    }
    if (_verifyText != "" && _phoneText != "") {
      Map<String, dynamic> map = new HashMap();
      map["mobile"] = _phoneText;
      map["code"] = _verifyText;
      EasyLoading.show(status: 'loading...');

      HttpUtils.requestHttp(
        ApiConstant.loginApp_phone,
        parameters: map,
        method: HttpUtils.POST,
        onSuccess: (data) async {
          EasyLoading.showSuccess('登录成功');
          var spUtils = SpUtils();
          spUtils.setStorage(SpConstant.Token, data["token"]);
          spUtils.setStorage(SpConstant.IsLogin, true);
          spUtils.setStorage(SpConstant.Uid, data["uid"]);
          HttpUtils.clear();

          bus.emit(EventConstant.GetUserInfo, null);

          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        onError: (code, error) {
          EasyLoading.showError(error ?? "");
        },
      );
      print("登录");
    }
    setState(() {});
  }

  void changeToAccountLogin() {
    NavigatorUtil.push(context, accountLoginPage());
  }
}
