
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
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/widget/base_web.dart';

////设置密码页面
// ignore: camel_case_types
class setPasswordPage extends StatefulWidget {
  String accountStr;
  int sqId;
  String sqAnswer;

  setPasswordPage({Key key, this.accountStr, this.sqId, this.sqAnswer})
      : super(key: key);

  @override
  _setPasswordPageState createState() => _setPasswordPageState();
}

class _setPasswordPageState extends State<setPasswordPage> {
  String _paswordErrorStr = null;
  String _confirmPasswordErrorStr = null;

  String _passwordText = "";
  String _confirmPasswordText = "";

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
                  "设置密码",
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
                              NavigatorUtil.push(context, BaseWebView(
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
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z]|[0-9.]")),
                    LengthLimitingTextInputFormatter(16)
                    //只允许输入字母
                  ],
                  // keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _passwordText = value;
                  },
                  decoration: InputDecoration(
                    labelText: "请输入6~16位字母或数字",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,

                    errorText: _paswordErrorStr,
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
                    _confirmPasswordText = value;
                  },
                  decoration: InputDecoration(
                    labelText: "请再次确认密码",
                    errorText: _confirmPasswordErrorStr,
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
                      "登录",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.WhiteColor),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void loginBtnAction() {
    if (_passwordText == "") {
      _paswordErrorStr = "请正确输入6-16位字母或数字";
    } else {
      _paswordErrorStr = null;
    }
    if (_confirmPasswordText != _passwordText) {
      _confirmPasswordErrorStr = "两次密码输入不一致";
    } else {
      _confirmPasswordErrorStr = null;
    }

    if (_confirmPasswordText != "" &&
        _passwordText != "" &&
        _confirmPasswordText == _passwordText) {
      _paswordErrorStr = null;
      _confirmPasswordErrorStr = null;

      Map<String, dynamic> map = new HashMap();
      map["sq_id"] = widget.sqId;
      map["sq_answer"] = widget.sqAnswer;
      map["username"] = widget.accountStr;
      map["password"] = _confirmPasswordText;

      EasyLoading.show(status: 'loading...');
      HttpUtils.requestHttp(
        ApiConstant.pwdBy_answer,
        parameters: map,
        method: HttpUtils.POST,
        onSuccess: (data) {
          EasyLoading.showSuccess("设置成功");
          loginAction();
        },
        onError: (code, error) {
          EasyLoading.showError(error ?? "");
        },
      );
    }
    setState(() {});
  }

  Future<void> loginAction() async {
    Map<String, dynamic> map = new HashMap();
    map["username"] = widget.accountStr;
    map["password"] = _confirmPasswordText;
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

    setState(() {});
  }
}
