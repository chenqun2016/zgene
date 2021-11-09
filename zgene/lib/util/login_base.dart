import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/userInfo_model.dart';
import 'package:zgene/pages/login/bindPhone_login.dart';
import 'package:zgene/pages/login/main_login.dart';

import '../main.dart';
import '../constant/common_constant.dart';

class BaseLogin {
  static login() {
    // if (CommonConstant.Svc_Msg_Status) {
    //   Global.navigatorKey.currentState.pushAndRemoveUntil(
    //       new MaterialPageRoute(
    //           builder: (BuildContext context) => phoneLoginPage()),
    //       (route) => true);
    // } else {
    Global.navigatorKey.currentState.pushAndRemoveUntil(
        new MaterialPageRoute(
            builder: (BuildContext context) => MainLoginPage()),
        (route) => true);
    // }
  }

  static bindPhone() {
    Global.navigatorKey.currentState.pushAndRemoveUntil(
        new MaterialPageRoute(
            builder: (BuildContext context) => BindPhoneLoginPage()),
        (route) => true);

    // }
  }
}
