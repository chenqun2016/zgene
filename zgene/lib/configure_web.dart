import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:js' as js;
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:js/js.dart';

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
  }
  // 判断是否在微信Webview内
  CommonConstant.isInWechatWeb = js.context.callMethod('InWechatWeb');
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
