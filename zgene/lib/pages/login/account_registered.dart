

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
import 'package:zgene/pages/login/down_push_content_view.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/widget/base_web.dart';

////账号注册
class registeredPage extends StatefulWidget {
  registeredPage({Key  key}) : super(key: key);

  @override
  _registeredPageState createState() => _registeredPageState();
}

class _registeredPageState extends State<registeredPage> {
  String _accountErrorStr = null;
  String _passwordErrorStr = null;
  String _confirmPasswordErrorStr = null;
  String _encryptedPasswordErrorStr = null;

  String _accountStr = "";
  String _passwordStr = "";
  String _confirmPasswordStr = "";
  String _encryptedPasswordStr = "";
  String _encryptedStr = "";

  Color _encryBorderColor = ColorConstant.LineMainColor;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  List questionArray = [];
  List questionDicArray = [];
  int selectId = -1;

  getHttp() {
    EasyLoading.show(status: 'loading...');
    // Map<String, dynamic> map = new HashMap();
    HttpUtils.requestHttp(
      ApiConstant.securityQuestion,
      // parameters: map,
      method: HttpUtils.GET,
      onSuccess: (data) {
        print(data.toString());
        EasyLoading.dismiss();
        questionDicArray = data["items"] ?? [];
        questionArray = [];
        for (var item in questionDicArray) {
          questionArray.add(item["question"]);
        }

        setState(() {});
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
        print(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Items album = Items.fromJson(list[index]);
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(0),
        child: Container(
          color: ColorConstant.WhiteColor,
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
                  top: 33,
                  left: 33,
                ),
                child: Text(
                  "账号",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextMainColor,
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
                  onChanged: (value) {
                    _accountStr = value;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z]|[0-9.]")),
                    LengthLimitingTextInputFormatter(16)
                    //只允许输入字母
                  ],
                  decoration: InputDecoration(
                    enabledBorder: new UnderlineInputBorder(
                      // 不是焦点的时候颜色
                      borderSide:
                          BorderSide(color: ColorConstant.LineMainColor),
                    ),
                    labelText: "请输入4~16位字母或数字",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,。。。。。。。。。
                    errorText: _accountErrorStr,
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
                  top: 33,
                  left: 33,
                ),
                child: Text(
                  "密码",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextMainColor,
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
                  onChanged: (value) {
                    _passwordStr = value;
                  },
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z]|[0-9.]")),
                    LengthLimitingTextInputFormatter(16)
                    //只允许输入字母
                  ],
                  decoration: InputDecoration(
                    labelText: "请输入6~16位字母或数字",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
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
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                  left: 33,
                  right: 33,
                ),
                child: TextField(
                  obscureText: true,

                  // keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _confirmPasswordStr = value;
                  },
                  decoration: InputDecoration(
                    labelText: "请在次确认密码",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
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
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 33,
                  left: 33,
                ),
                child: Text(
                  "密保",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextMainColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12, left: 32, right: 32),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  //设置四周圆角 角度
                  //设置四周边框
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: new Border.all(width: 1, color: _encryBorderColor),
                ),
                child: ContentView.dropdownView(
                  controller: _controller,
                  contentList: questionArray.toSet().toList(),
                  hintText: '请选择一个密保问题',
                  onChanged: (title) {
                    _encryptedStr = title;
                    for (var item in questionDicArray) {
                      if (title == item["question"]) {
                        selectId = item["id"];
                        break;
                      }
                    }
                  },
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
                  onChanged: (value) {
                    _encryptedPasswordStr = value;
                  },
                  decoration: InputDecoration(
                    labelText: "请输入答案",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                    errorText: _encryptedPasswordErrorStr,
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
                  margin: EdgeInsets.only(top: 160, left: 33),
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
                      "注册并登录",
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
                  margin: EdgeInsets.only(top: 13, bottom: 75),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginBtnAction() {
    if (_accountStr == "" ||
        _passwordStr == "" ||
        _passwordStr != _confirmPasswordStr ||
        selectId == -1 ||
        _encryptedPasswordStr == "") {
      if (_accountStr == "" ||
          _accountStr.length < 4 ||
          _accountStr.length > 16) {
        _accountErrorStr = "请输入4-16位字母或数字";
      } else {
        _accountErrorStr = null;
      }

      if (_passwordStr == "") {
        _passwordErrorStr = "请输入6-16位字母或数字";
      } else {
        _passwordErrorStr = null;
      }
      if (_passwordStr != _confirmPasswordStr) {
        _confirmPasswordErrorStr = "两次密码输入不一致";
      } else {
        _confirmPasswordErrorStr = null;
      }

      if (selectId == -1) {
        _encryBorderColor = Colors.red;
      } else {
        _encryBorderColor = ColorConstant.LineMainColor;
      }

      if (_encryptedPasswordStr == "") {
        _encryptedPasswordErrorStr = "请输密保答案";
      } else {
        _encryptedPasswordErrorStr = null;
      }

      setState(() {});

      return;
    } else {
      _encryptedPasswordErrorStr = null;
      _encryBorderColor = ColorConstant.LineMainColor;
      _accountErrorStr = null;
      _confirmPasswordErrorStr = null;
      _passwordErrorStr = null;
      setState(() {});
    }

    Map<String, dynamic> map = new HashMap();
    map["username"] = _accountStr;
    map["password"] = _confirmPasswordStr;
    map["sq_id"] = selectId;
    map["sq_answer"] = _encryptedPasswordStr;
    EasyLoading.show(status: 'loading...');

    HttpUtils.requestHttp(
      ApiConstant.registerPwd,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) {
        print(data.toString());

        EasyLoading.showSuccess('注册成功');
        loginAction();
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
      },
    );
  }

  Future<void> loginAction() async {
    Map<String, dynamic> map = new HashMap();
    map["username"] = _accountStr;
    map["password"] = _confirmPasswordStr;
    EasyLoading.show(status: 'loading...');

    HttpUtils.requestHttp(
      ApiConstant.loginApp_pwd,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) async {
        EasyLoading.showSuccess('登录成功');

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
