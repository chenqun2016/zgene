import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/app_notification.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/event/event_bus.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/pages/login/bindPhone_login.dart';
import 'package:zgene/pages/login/phone_login.dart';
import 'package:zgene/util/base_widget.dart';

import 'package:flutter/material.dart';
import 'package:zgene/util/notification_utils.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/widget/base_web.dart';

class MainLoginPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _MainLoginPageState();
  }
}

class _MainLoginPageState extends BaseWidgetState<MainLoginPage> {
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = true;
    setWantKeepAlive = true;
    backImgPath = "assets/images/login/icon_mainLogin_backImg.png";

    // NotificationCenter.instance.addObserver(NotificationName.WxCode, (object) {
    //   if (object != null) {
    //     wxLoginHttp(object);
    //     print("{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}}");
    //   }
    // });
    bus.on(CommonConstant.WxCode, (arg) {
      wxLoginHttp(arg);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    NotificationCenter.instance.removeNotification(NotificationName.WxCode);
    bus.off(CommonConstant.WxCode);
  }

  var isAgreePrivacy = false;
  var enterThe = false;

//
  @override
  Widget viewPageBody(BuildContext context) {
    // 当前widget的具体内容
    return Container(
        child: Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 0),
            // padding: EdgeInsets.,
            child: Image(
              image: AssetImage("assets/images/login/icon_login_logo.png"),
              height: 160.w,
              width: 160.w,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Text(
              "欢迎登录Z基因",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 30.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 73.h),
              width: 312.w,
              height: 54.h,
              child: OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                          width: 0, color: ColorConstant.WhiteColor)),
                      backgroundColor: MaterialStateProperty.all(
                          ColorConstant.MainBlueColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.h)))),
                  onPressed: () {
                    selectPhoneLogin();
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        Image(
                          image: AssetImage(
                              "assets/images/login/iocn_login_phone.png"),
                          height: 36.w,
                          width: 36.w,
                          fit: BoxFit.fill,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 11.w),
                          child: Text(
                            "手机号登录",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.WhiteColor,
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ))),
          Offstage(
            offstage: !CommonConstant.Is_WeChat_Installed,
            child: Container(
                margin: EdgeInsets.only(top: 16.h),
                width: 312.w,
                height: 54.h,
                child: OutlinedButton(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(
                            width: 0, color: ColorConstant.WhiteColor)),
                        backgroundColor: MaterialStateProperty.all(
                            ColorConstant.WxGreenColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.h)))),
                    onPressed: () {
                      loginWX();
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(child: Container()),
                          Image(
                            image: AssetImage(
                                "assets/images/login/iocn_login_weixin.png"),
                            height: 36.w,
                            width: 36.w,
                            fit: BoxFit.fill,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 11.w),
                            child: Text(
                              "微信号登录",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                color: ColorConstant.WhiteColor,
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ))),
          ),
          Offstage(
            offstage:
                !(CommonConstant.Is_WeChat_Installed && PlatformUtils.isIOS),
            child: Container(
                margin: EdgeInsets.only(top: 16.h),
                width: 312.w,
                height: 54.h,
                child: OutlinedButton(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(
                            width: 0, color: ColorConstant.WhiteColor)),
                        backgroundColor: MaterialStateProperty.all(
                            ColorConstant.AppleBlackColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.h)))),
                    onPressed: () {
                      LoginApple();
                      // toBindingPhone();
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(child: Container()),
                          Image(
                            image: AssetImage(
                                "assets/images/login/iocn_login_apple.png"),
                            height: 36.w,
                            width: 36.w,
                            fit: BoxFit.fill,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 11.w),
                            child: Text(
                              "Apple登录",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                color: ColorConstant.WhiteColor,
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ))),
          ),
          Stack(children: [
            Container(
              margin: EdgeInsets.only(
                top: 20.h,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                          width: 12.w,
                          height: 12.w,
                          child: IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                isAgreePrivacy = !isAgreePrivacy;
                                if (isAgreePrivacy) {
                                  enterThe = false;
                                } else {
                                  enterThe = true;
                                }
                                setState(() {});
                              },
                              icon: Image(
                                image: !isAgreePrivacy
                                    ? AssetImage(
                                        "assets/images/login/icon_login_circle.png")
                                    : AssetImage(
                                        "assets/images/login/icon_login_agreeCircle.png"),
                                height: 12.w,
                                width: 12.w,
                                fit: BoxFit.fill,
                              ))),
                      Container(
                        padding: EdgeInsets.only(left: 4.w),
                        child: RichText(
                            text: TextSpan(
                                text: "我已阅读Z基因",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.PromptGrayColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    isAgreePrivacy = !isAgreePrivacy;
                                    if (isAgreePrivacy) {
                                      enterThe = false;
                                    } else {
                                      enterThe = true;
                                    }
                                    setState(() {});
                                  },
                                children: [
                              TextSpan(
                                  text: "《隐私政策》",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.MainBlueColor,
                                    // decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print("点击隐私");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BaseWebView(
                                                    url: CommonConstant.privacy,
                                                    title: "隐私政策",
                                                  )));
                                    }),
                              TextSpan(
                                  text: "和",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.PromptGrayColor,
                                  )),
                              TextSpan(
                                  text: "《用户协议》",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.MainBlueColor,
                                    // decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print("点击服务");

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BaseWebView(
                                                    url: CommonConstant
                                                        .agreement,
                                                    title: "用户协议",
                                                  )));
                                    }),
                            ])),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  Container(
                    height: 20.h,
                  )
                ],
              ),
            ),
            Positioned(
                left: 10.w,
                child: InkResponse(
                  highlightColor: Colors.transparent,
                  radius: 0.0,
                  onTap: () {
                    isAgreePrivacy = !isAgreePrivacy;
                    if (isAgreePrivacy) {
                      enterThe = false;
                    } else {
                      enterThe = true;
                    }

                    setState(() {});
                  },
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    // decoration: new BoxDecoration(
                    //   color: ColorConstant.WhiteColorB2,
                    //   borderRadius: BorderRadius.all(Radius.circular(20.h)),
                    //   //设置四周边框
                    //   border: new Border.all(
                    //       width: 1, color: ColorConstant.WhiteColor),
                    // ),
                  ),
                ))
          ]),
          Offstage(
            offstage: !enterThe,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 60.w, top: 0),
                  child: Text(
                    "请确认已阅读Z基因隐私政策",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorConstant.MainRed,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  void loginWX() {
    if (!isAgreePrivacy) {
      enterThe = true;
      setState(() {});

      return;
    }
    enterThe = false;
    setState(() {});
    sendWeChatAuth(scope: "snsapi_userinfo", state: "sivms_state").then((data) {
      setState(() {
        print("拉取微信用户信息：" + data.toString());
      });
    }).catchError((e) {
      print('weChatLogin  e  $e');
    });
  }

  Future<void> LoginApple() async {
    // SignInWithAppleButton(
    //   onPressed: () async {

    //   },
    // );
    if (!isAgreePrivacy) {
      enterThe = true;
      setState(() {});
      return;
    }
    enterThe = false;
    setState(() {});
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credential != null) {
      debugPrint(
          "facebook userInfo : userId=${credential.userIdentifier}   email=${credential.email}  giveName=${credential.givenName}   familyName=${credential.familyName}");

      appleLoginHttp(credential.userIdentifier, credential.userIdentifier,
          credential.givenName, credential.familyName);
    }
  }

  void wxLoginHttp(String code) {
    Map<String, dynamic> map = new HashMap();
    map["code"] = code;

    EasyLoading.show(status: 'loading...');

    HttpUtils.requestHttp(
      ApiConstant.login_wx,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) {
        var spUtils = SpUtils();
        spUtils.setStorage(SpConstant.Token, data["token"]);
        spUtils.setStorage(SpConstant.IsLogin, true);
        HttpUtils.clear();
        // NotificationCenter.instance
        //     .postNotification(NotificationName.GetUserInfo, null);
        bus.emit(CommonConstant.refreshMine);
        if (data["has_mobile"] == null) {
          EasyLoading.showSuccess("登陆成功");

          Navigator.popUntil(context, ModalRoute.withName('/'));
        } else {
          EasyLoading.dismiss();
          toBindingPhone();
        }
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
      },
    );
  }

  void appleLoginHttp(
      String userId, String email, String giveName, String familyName) {
    Map<String, dynamic> map = new HashMap();
    map["userId"] = userId;
    map["email"] = email;
    map["giveName"] = giveName;
    map["familyName"] = familyName;

    EasyLoading.show(status: 'loading...');

    HttpUtils.requestHttp(
      ApiConstant.login_apple,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) {
        var spUtils = SpUtils();
        spUtils.setStorage(SpConstant.Token, data["token"]);
        spUtils.setStorage(SpConstant.IsLogin, true);
        HttpUtils.clear();
        if (data["has_mobile"] == null) {
          EasyLoading.showSuccess("登陆成功");
          bus.emit(CommonConstant.refreshMine);
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          toBindingPhone();
        }
      },
      onError: (code, error) {
        EasyLoading.dismiss();
        EasyLoading.showError(error ?? "");
      },
    );
  }

  void selectPhoneLogin() {
    if (!isAgreePrivacy) {
      enterThe = true;
      setState(() {});

      return;
    }
    enterThe = false;
    setState(() {});
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhoneLoginPage()));
  }

  void toBindingPhone() {
    if (!isAgreePrivacy) {
      enterThe = true;
      setState(() {});

      return;
    }
    enterThe = false;
    setState(() {});
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BindPhoneLoginPage()));
  }
}
