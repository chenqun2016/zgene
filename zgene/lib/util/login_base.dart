import 'package:flutter/material.dart';
import 'package:zgene/pages/login/account_login_page.dart';
import 'package:zgene/pages/login/phone_login_page.dart';
import '../main.dart';
import '../constant/common_constant.dart';

class BaseLogin {
  static login() {
    if (CommonConstant.Svc_Msg_Status) {
      Global.navigatorKey.currentState.pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (BuildContext context) => phoneLoginPage()),
          (route) => true);
    } else {
      Global.navigatorKey.currentState.pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (BuildContext context) => accountLoginPage()),
          (route) => true);
    }
  }
}
