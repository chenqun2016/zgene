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
        String type = call.arguments["type"].toString();
        CommonUtils.globalToUrl(type: int.parse(type), url: url);
      }
      return Future.value(0);
    });
  }
}
