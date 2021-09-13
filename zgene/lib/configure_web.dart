import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:js' as js;
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/constant/sp_constant.dart';

void configureApp() {
  setUrlStrategy(HashUrlStrategy());
}

void webLogin() {
  // 如果是web则需要进行一些js操作
  var res = js.context.callMethod('GetCookie', ['jwt']);
  // print("xxxxxrs = ${res}");
  if (res != null) {
    var spUtils = SpUtils();
    spUtils.setStorage(SpConstant.Token, res);
    spUtils.setStorage(SpConstant.IsLogin, true);
  }
}
