import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/app_notification.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/pages/login/bindPhone_login.dart';
import 'package:zgene/pages/login/phone_login.dart';
import 'package:zgene/util/base_widget.dart';

import 'package:flutter/material.dart';
import 'package:zgene/util/notification_utils.dart';
import 'package:zgene/util/screen_utils.dart';
import 'package:zgene/util/sp_utils.dart';

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
    weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
      if (res is WeChatAuthResponse) {
        int errCode = res.errCode;
        // MyLogUtil.d('微信登录返回值：ErrCode :$errCode  code:${res.code}');
        if (errCode == 0) {
          String code = res.code;
          print('wxwxwxwxwxwxwx' + code);
          //把微信登录返回的code传给后台，剩下的事就交给后台处理
          wxLoginHttp(code);
          // showToast("用户同意授权成功");
        } else if (errCode == -4) {
          // showToast("用户拒绝授权");
          print('wxwxwxwxwxwxwx用户拒绝授权');
        } else if (errCode == -2) {
          // showToast("用户取消授权");
          print('wxwxwxwxwxwxwx用户取消授权');
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var isAgreePrivacy = false;

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
              "欢迎登陆Z基因",
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
          Container(
              margin: EdgeInsets.only(top: 16.h),
              width: 312.w,
              height: 54.h,
              child: OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                          width: 0, color: ColorConstant.WhiteColor)),
                      backgroundColor:
                          MaterialStateProperty.all(ColorConstant.WxGreenColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.h)))),
                  onPressed: () {
                    // toBindingPhone();
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
          Container(
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
          Container(
            margin: EdgeInsets.only(
              top: 13.h,
            ),
            child: Row(
              children: [
                Expanded(child: Container()),
                Container(
                    width: 12.w,
                    height: 12.w,
                    child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          isAgreePrivacy = !isAgreePrivacy;
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
                          children: [
                        TextSpan(
                            text: "《隐私条款》",
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => myBaseWebView(
                                //               url: CommonConstant.agreement,
                                //               title: "用户协议",
                                //             )));
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
                            text: "《服务协议》",
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

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => myBaseWebView(
                                //               url: CommonConstant.privacy,
                                //               title: "隐私政策",
                                //             )));
                              }),
                      ])),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void loginWX() {
    print("微信登录");
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
        EasyLoading.dismiss();
        var spUtils = SpUtils();
        spUtils.setStorage(SpConstant.Token, data["token"]);
        spUtils.setStorage(SpConstant.IsLogin, true);

        if (data["has_mobile"]) {
          HttpUtils.clear();

          NotificationCenter.instance
              .postNotification(NotificationName.GetUserInfo, null);

          Navigator.popUntil(context, ModalRoute.withName('/'));
        } else {
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
        EasyLoading.dismiss();
        var spUtils = SpUtils();
        spUtils.setStorage(SpConstant.Token, data["token"]);
        spUtils.setStorage(SpConstant.IsLogin, true);

        if (data["has_mobile"]) {
          HttpUtils.clear();

          NotificationCenter.instance
              .postNotification(NotificationName.GetUserInfo, null);

          Navigator.popUntil(context, ModalRoute.withName('/'));
        } else {
          toBindingPhone();
        }
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
      },
    );
  }

  void selectPhoneLogin() {
    if (!isAgreePrivacy) {
      return;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhoneLoginPage()));
  }

  void toBindingPhone() {
    if (!isAgreePrivacy) {
      return;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BindPhoneLoginPage()));
  }
}
