import 'package:flutter/services.dart';
import 'package:zgene/util/common_utils.dart';

class MethodChannelPlugin {
  static const MethodChannel _channel =
      const MethodChannel('com.jt.zgene.MethodChannel');

  ///开始录音
  static Future<dynamic> registHandler() async {
    print("-------------- registHandler");
    await _channel.setMethodCallHandler((MethodCall call) {
      if (call.method == "onPushData") {
        print("onPushData arguments==" + call.arguments.toString());
        String url = call.arguments["url"].toString();
        int type = -1;
        if (null != call.arguments["type"]) {
          try {
            type = int.parse(call.arguments["type"].toString());
          } catch (e) {
            print(e);
          }
        }
        CommonUtils.globalToUrl(type: type, url: url);
      }
      return Future.value(0);
    });
  }
}
