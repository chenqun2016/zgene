

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

import 'package:zgene/http/http_utils.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/login/account_registered.dart';
import 'package:zgene/pages/login/phone_login_page.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/widget/base_web.dart';

import 'encrypted_find.dart';

////账号登录
class accountLoginPage extends StatefulWidget {
  accountLoginPage({Key key}) : super(key: key);

  @override
  _accountLoginPageState createState() => _accountLoginPageState();
}

class _accountLoginPageState extends State<accountLoginPage> {
  String _accountErrorStr = null;
  String _passwordErrorStr = null;

  String _accountText = "";
  String _passwordText = "";

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
              Row(
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
                        AssetImage(
                            "assets/images/mine/icon_mine_backArrow.png"),
                        size: 16,
                        color: ColorConstant.MainBlack,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: EdgeInsets.only(top: 53, right: 5),
                    padding: EdgeInsets.all(0),
                    height: 22,
                    child: TextButton(
                        onPressed: () {
                          toRegisteredAcction();
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        child: Text(
                          "注册",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.TextSecondColor,
                          ),
                        )),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 36,
                  left: 33,
                ),
                child: Text(
                  "账号登录",
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
                              NavigatorUtil.push(context, BaseWebView(
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
                              NavigatorUtil.push(context,BaseWebView(
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
                  // keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _accountText = value;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z]|[0-9.]")),
                    LengthLimitingTextInputFormatter(16)
                    //只允许输入字母
                  ],
                  decoration: InputDecoration(
                    labelText: "请输入账号",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                    errorText: _accountErrorStr,
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
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                  left: 33,
                  right: 33,
                ),
                child: TextField(
                  // keyboardType: TextInputType.number,
                  obscureText: true,
                  onChanged: (value) {
                    _passwordText = value;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z]|[0-9.]")),
                    LengthLimitingTextInputFormatter(16)
                    //只允许输入字母
                  ],
                  decoration: InputDecoration(
                    labelText: "请输入密码",
                    errorText: _passwordErrorStr,
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
                  ),
                  // inputFormatters: [LengthLimitingTextInputFormatter(6)],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18, left: 33),
                padding: EdgeInsets.all(0),
                height: 20,
                child: TextButton(
                    onPressed: () {
                      toEncrytedFind();
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Text(
                      "找回密码",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: Color(CommonConstant.THEME_COLOR),
                      ),
                    )),
              ),
              Container(
                  margin: EdgeInsets.only(top: 27, left: 33),
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
              Offstage(
                offstage: CommonConstant.Svc_Msg_Status ? false : true,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.only(top: 10),
                    child: TextButton(
                        onPressed: () {
                          changeToPhoneLogin();
                        },
                        child: Center(
                          child: Text(
                            '手机号登录',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeToPhoneLogin() {
    NavigatorUtil.push(context, phoneLoginPage());
  }

  Future<void> loginBtnAction() async {
    if (_accountText == "") {
      _accountErrorStr = "请输入账号";
    } else {
      _accountErrorStr = null;
    }
    if (_passwordText == "") {
      _passwordErrorStr = "请输入密码";
    } else {
      _passwordErrorStr = null;
    }
    if (_passwordText != "" && _accountText != "") {
      Map<String, dynamic> map = new HashMap();
      map["username"] = _accountText;
      map["password"] = _passwordText;
      EasyLoading.show(status: 'loading...');

      HttpUtils.requestHttp(
        ApiConstant.loginApp_pwd,
        parameters: map,
        method: HttpUtils.POST,
        onSuccess: (data) async {
          EasyLoading.showSuccess('登录成功');
          // SpConstant.Token = data["token"];
          var spUtils = SpUtils();
          spUtils.setStorage(SpConstant.Token, data["token"]);
          spUtils.setStorage(SpConstant.IsLogin, true);
          spUtils.setStorage(SpConstant.Uid, data["uid"]);
          HttpUtils.clear();

          bus.emit(EventBus.GetUserInfo, null);

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

  void toRegisteredAcction() {
    NavigatorUtil.push(context, registeredPage());

  }

  void toEncrytedFind() {
    if (_accountText == "") {
      _accountErrorStr = "请输入账号";
      setState(() {});
      return;
    } else {
      _accountErrorStr = null;
      setState(() {});
    }
    NavigatorUtil.push(context, encrytedFindPage(accountStr: _accountText));
  }
}
