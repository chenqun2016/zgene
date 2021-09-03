import 'package:connectivity/connectivity.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/models/msg_event.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/widget/base_web.dart';

///公共工具类
class CommonUtils {
  ///拼接图片和视频路径
  static String splicingUrl(String url) {
    if (url.isEmpty) {
      return "";
    }
    return CommonConstant.BASE_API + url;
  }

  ///判断网络是否可用
  ///0 - none | 1 - mobile | 2 - WIFI
  static Future<bool> isNetWorkAvailable() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          msg: "网络不可用",
          gravity: ToastGravity.CENTER,
          backgroundColor: ColorConstant.LineMainColor,
          textColor: ColorConstant.TextMainColor);
      return false;
    } else {
      return true;
    }
  }

  ///处理数量（过万以万为单位）
  static String getCountText(int count) {
    if (count >= 10000) {
      double tempCount = count.toDouble() / 10000;
      return formartNum(tempCount.toDouble(), 1) + "w";
    }
    return count.toString();
  }

  ///
  ///target  要转换的数字
  ///postion 要保留的位数
  ///isCrop  true 直接裁剪 false 四舍五入
  ///
  static String formartNum(num target, int postion, {bool isCrop = false}) {
    String t = target.toString();
    // 如果要保留的长度小于等于0 直接返回当前字符串
    if (postion < 0) {
      return t;
    }
    if (t.contains(".")) {
      String t1 = t.split(".").last;
      if (t1.length >= postion) {
        if (isCrop) {
          // 直接裁剪
          return t.substring(0, t.length - (t1.length - postion));
        } else {
          // 四舍五入
          return target.toStringAsFixed(postion);
        }
      } else {
        // 不够位数的补相应个数的0
        String t2 = "";
        for (int i = 0; i < postion - t1.length; i++) {
          t2 += "0";
        }
        return t + t2;
      }
    } else {
      // 不含小数的部分补点和相应的0
      String t3 = postion > 0 ? "." : "";

      for (int i = 0; i < postion; i++) {
        t3 += "0";
      }
      return t + t3;
    }
  }

  static EventBus _eventBus;

  //获取单例
  static EventBus getInstance() {
    if (_eventBus == null) {
      _eventBus = EventBus();
    }
    return _eventBus;
  }

  ///公共跳转链接
  static toUrl({context, url, type}) {
    var eventBus = getInstance();

    if (url == "/buy") {//购买
      //跳到购买
      eventBus.fire(MsgEvent(100, 1));
    } else if (url == "/my") {//我的
      //跳到我的
      eventBus.fire(MsgEvent(100, 3));
    } else if(url.contains('/webview')){//跳转浏览器
      var uri = Uri.dataFromString(url);
      Map<String, String> params = uri.queryParameters;
      launch(params['url']);

    } else {
      switch (type) {
        // type 0:无 1:HTTP 2:应用内 3:视频
        case 0:
          break;
        case 1:
          NavigatorUtil.push(
              context,
              BaseWebView(
                url: url,
                title: "",
              ));
          break;
        case 2:
          var uri = Uri.dataFromString(url);
          Map<String, String> params = uri.queryParameters;
          var id = params['id'];
          if(id==null){
            Navigator.of(context).pushNamed(url);
          }else{
            Navigator.of(context).pushNamed(url.split("?")[0], arguments:id);
          }
          break;
        case 3:
          break;
      }
    }
  }
}
