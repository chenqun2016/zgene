import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/sp_utils.dart';

import 'common_utils.dart';

class GetuiUtils {
  static config() {
    Getuiflut().addEventHandler(
      onReceiveClientId: (String message) async {
        print("flutter onReceiveClientId: $message");
      },
      onReceiveMessageData: (Map<String, dynamic> msg) async {
        print("flutter onReceiveMessageData: $msg");

        if (PlatformUtils.isAndroid &&
            !CommonConstant.AppLifecycleStateResumed) {
          var payload = json.decode(msg["payload"].toString());

          CommonUtils.globalToUrl(type: payload["type"], url: payload["url"]);
        }
      },
      onNotificationMessageArrived: (Map<String, dynamic> msg) async {
        print("flutter onNotificationMessageArrived: $msg");
        print("++++++++++++++++");
      },
      onNotificationMessageClicked: (Map<String, dynamic> msg) async {
        print("flutter onNotificationMessageClicked: $msg");
      },
      onRegisterDeviceToken: (String message) async {},
      onReceivePayload: (Map<String, dynamic> message) async {
        print("flutter onReceivePayload: $message");
        print("-------------------");

        if (Platform.isIOS && !CommonConstant.AppLifecycleStateResumed) {
          var payload = json.decode(message["payloadMsg"].toString());
          print(payload);
          CommonUtils.globalToUrl(type: payload["type"], url: payload["url"]);
        }
      },
      onReceiveNotificationResponse: (Map<String, dynamic> msg) async {
        print("flutter onReceiveNotificationResponse : $msg");
        // if (Platform.isIOS) {
        //   var payload = json.decode(msg["payload"]);
        //   print(payload);
        //   CommonUtils.globalToUrl(type: payload["type"], url: payload["url"]);
        // }
      },
      onAppLinkPayload: (String message) async {},
      onRegisterVoipToken: (String message) async {},
      onReceiveVoipPayLoad: (Map<String, dynamic> message) async {},
    );
  }

  static Future<void> initGetuiSdk() async {
    try {
      Getuiflut.initGetuiSdk;
    } catch (e) {
      e.toString();
    }
  }

  static Future<void> getClientId() async {
    String getClientId;
    try {
      getClientId = await Getuiflut.getClientId;
      print(getClientId);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> getLaunchNotification() async {
    Map info;
    try {
      info = await Getuiflut.getLaunchNotification;
      print(info);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> bindAlias() async {
    var spUtils = SpUtils();

    print("uid == " + spUtils.getStorageDefault(SpConstant.Uid, 0).toString());
    if (spUtils.getStorageDefault(SpConstant.IsLogin, false)) {
      if (spUtils.getStorageDefault(SpConstant.Uid, 0) != 0) {
        Getuiflut().bindAlias(
            spUtils.getStorageDefault(SpConstant.Uid, 0).toString(),
            DateTime.now().millisecondsSinceEpoch.toString());
      }
    }
  }

  static Future<void> resetBadge() async {
    // ignore: unnecessary_statements
    Getuiflut().resetBadge;
  }
}
