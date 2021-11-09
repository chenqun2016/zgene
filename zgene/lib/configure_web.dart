import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zgene/models/userInfo_model.dart';
import 'package:zgene/util/login_base.dart';
import 'dart:js' as js;
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:js/js.dart';

import 'constant/api_constant.dart';
import 'http/http_utils.dart';

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
        UserInfoModel userInfoModel = UserInfoModel.fromJson(data);
        userInfo = userInfoModel;
        if (userInfo.mobile == "") {
          print("登录1");

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
