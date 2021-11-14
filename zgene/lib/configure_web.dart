import 'dart:js' as js;

import 'package:base/http/http_utils.dart';
import 'package:base/util/sp_utils.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/models/userInfo_model.dart';
import 'package:zgene/util/login_base.dart';

import 'constant/api_constant.dart';

// ignore: missing_js_lib_annotation
@JS('helloDart')
external set _helloDart(void Function() f);

void _intHelloDart() {
  print('Hello from Dart!');
}

void configureApp() {
  setUrlStrategy(HashUrlStrategy());
  _helloDart = allowInterop(_intHelloDart);
}

void webLogin() {
  // 如果是web则需要进行一些js操作
  var res = js.context.callMethod('GetCookie', ['jwt']);
  if (res != null) {
    var spUtils = SpUtils();
    spUtils.setStorage(SpConstant.Token, res);
    spUtils.setStorage(SpConstant.IsLogin, true);
    UserInfoModel userInfo = UserInfoModel();
    HttpUtils.requestHttp(
      ApiConstant.userInfo,
      method: HttpUtils.GET,
      onSuccess: (data) {
        print(data);
        print("微信登录成功获取用户信息");

        UserInfoModel userInfoModel = UserInfoModel.fromJson(data);
        userInfo = userInfoModel;
        if (userInfo.mobile == "" || userInfo.mobile == null) {
          print("进入绑定手机号");
          BaseLogin.bindPhone();
        }
      },
    );
  }
  // 判断是否在微信Webview内
  CommonConstant.isInWechatWeb = js.context.callMethod('InWechatWeb');
  CommonConstant.isInWechatMini = js.context.callMethod('InWechatMini');

  CommonConstant.wechatWebOpenID =
      js.context.callMethod('GetCookie', ['openid']);
}

void webWeixinPay(parms) {
  js.context.callMethod('WeixinPay', [parms]);
}

void webWeixinLogin() {
  js.context.callMethod('JumpLogin');
}

void webShowToast(msg) {
  js.context.callMethod('showToast', [msg]);
}

void webWeixinScanCode() {
  js.context.callMethod('WxScanCode');
}

void webScanCallback(scanCallback) {
  js.context["scanCallback"] = scanCallback;
}

void webPlayVideoInWxMini(url) {
  js.context.callMethod('playVideoInWxMini', [url]);
}

void weNavJump(navigateJump) {
  js.context["baseWebNavigate"] = navigateJump;
}
