import 'package:connectivity/connectivity.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/models/msg_event.dart';
import 'package:zgene/models/order_step_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/home/video_page.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/widget/base_web.dart';

import '../main.dart';
import 'login_base.dart';

///公共工具类
class CommonUtils {
  ///拼接图片和视频路径
  static String splicingUrl(String url) {
    print("splicingUrl==" + url);
    if (null == url || url.isEmpty) {
      return "";
    }
    return CommonConstant.BASE_API + url;
  }

  ///拼接图片路径
  static String splicingImageId(String id) {
    if (id.isEmpty) {
      return "";
    }
    return CommonConstant.BASE_API + "/public/statics/img/" + id + ".png";
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
    print("--------------------");
    print(t);
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

  // 服务器数据除以1000
  static String formatMoney(int money) {
    // return formartNum(money / 1000, 2);
    return subNumberText((money / 1000).toString());
  }

  static String subNumberText(String result) {
    if (result == null) {
      return "";
    }
    if (result.contains(".")) {
      // 是小数
      while (true) {
        if (result.substring(result.length - 1, result.length) == '0')
          result = result.substring(0, result.length - 1);
        else {
          if (result.endsWith(".")) {
            result = result.substring(0, result.length - 1);
          }
          break;
        }
      }
    }
    return result;
  }

  static EventBus _eventBus;

  //获取单例
  static EventBus getInstance() {
    if (_eventBus == null) {
      _eventBus = EventBus();
    }
    return _eventBus;
  }

  static const String URL_BUY = "/buy";
  static const String URL_MY = "/my";
  static const String URL_REPORT = "/report";

  ///跳转采集引导页
  static toCollectionGuide(BuildContext context, {bool pop}) {
    if (null != pop && pop) {
      int index = 0;
      Navigator.of(context).pushNamedAndRemoveUntil("/article_detail", (route) {
        index++;
        if (index <= 2) {
          return false;
        }
        return true;
      }, arguments: "9528267533900");
    } else {
      Navigator.of(context)
          .pushNamed("/article_detail", arguments: "9528267533900");
    }
  }

  ///公共跳转链接
  static toUrl({context, String url, type, archives}) {
    print("000000000000000000000");

    print("url==$url+type==${type.toString()}");
    var eventBus = getInstance();

    if (url == URL_BUY) {
      //购买
      //跳到购买
      eventBus.fire(MsgEvent(100, 1));
    } else if (url == URL_MY) {
      //我的
      //跳到我的
      eventBus.fire(MsgEvent(100, 3));
    } else if (url.contains(URL_REPORT) && !url.contains("_")) {
      //报告
      var uri = Uri.dataFromString(url);
      Map<String, String> params = uri.queryParameters;
      var id = params['id'];
      eventBus.fire(MsgEvent(100, 2, arg: id));
    } else if (url.contains('/webview')) {
      //跳转浏览器
      var uri = Uri.dataFromString(url);
      Map<String, String> params = uri.queryParameters;
      launch(params['url']);
    } else {
      switch (type) {
        // type 0:无 1:HTTP 2:应用内 3:视频
        case 0:
          if (null != archives) {
            NavigatorUtil.push(
                context,
                BaseWebView(
                    url: ApiConstant.getH5DetailUrl(archives.id.toString()),
                    title: archives.title));
          }
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
          var urlName = url.split("?")[0];
          if (urlName == CommonConstant.ROUT_bind_collector ||
              urlName == CommonConstant.ROUT_back_collector ||
              urlName == CommonConstant.ROUT_order_detail ||
              urlName == CommonConstant.ROUT_order_step_detail ||
              urlName == CommonConstant.ROUT_my_order ||
              urlName == CommonConstant.ROUT_my_info ||
              urlName == CommonConstant.ROUT_my_address ||
              urlName == CommonConstant.ROUT_my_report_list ||
              urlName == CommonConstant.ROUT_my_message) {
            if (!SpUtils().getStorageDefault(SpConstant.IsLogin, false)) {
              BaseLogin.login();
              return;
            }
          }
          Uri uri = Uri.dataFromString(url);
          Map<String, String> params = uri.queryParameters;
          if (params == null || params.length <= 0) {
            print(123);
            Navigator.of(context).pushNamed(url);
          } else if (params.length == 1 && params.containsKey('id')) {
            var id = params['id'];
            print(456);
            Navigator.of(context).pushNamed(url.split("?")[0], arguments: id);
          } else {
            print(789);
            Navigator.of(context)
                .pushNamed(url.split("?")[0], arguments: params);
          }

          break;
        case 3:
          NavigatorUtil.push(context, VideoPage(linkUrl: url));
          break;
      }
    }
  }

  ///公共跳转链接
  static globalToUrl({String url, type}) {
    print("000000000000000000000");
    print("url==$url+type==${type.toString()}");
    var eventBus = getInstance();

    if (url == URL_BUY) {
      //购买
      //跳到购买
      eventBus.fire(MsgEvent(100, 1));
    } else if (url == URL_MY) {
      //我的
      //跳到我的
      eventBus.fire(MsgEvent(100, 3));
    } else if (url.contains(URL_REPORT) && !url.contains("_")) {
      //报告
      var uri = Uri.dataFromString(url);
      Map<String, String> params = uri.queryParameters;
      var id = params['id'];
      eventBus.fire(MsgEvent(100, 2, arg: id));
    } else if (url.contains('/webview')) {
      //跳转浏览器
      var uri = Uri.dataFromString(url);
      Map<String, String> params = uri.queryParameters;
      launch(params['url']);
    } else {
      switch (type) {
        // type 0:无 1:HTTP 2:应用内 3:视频
        case 0:
          break;
        case 1:
          // NavigatorUtil.push(
          //     context,
          //     BaseWebView(
          //       url: url,
          //       title: "",
          //     ));
          Global.navigatorKey.currentState.pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (BuildContext context) => BaseWebView(
                        url: url,
                        title: "",
                      )),
              (route) => true);
          break;
        case 2:
          var urlName = url.split("?")[0];
          if (urlName == CommonConstant.ROUT_bind_collector ||
              urlName == CommonConstant.ROUT_back_collector ||
              urlName == CommonConstant.ROUT_order_detail ||
              urlName == CommonConstant.ROUT_order_step_detail ||
              urlName == CommonConstant.ROUT_my_order ||
              urlName == CommonConstant.ROUT_my_info ||
              urlName == CommonConstant.ROUT_my_address ||
              urlName == CommonConstant.ROUT_my_report_list ||
              urlName == CommonConstant.ROUT_my_message) {
            if (!SpUtils().getStorageDefault(SpConstant.IsLogin, false)) {
              BaseLogin.login();
              return;
            }
          }
          Uri uri = Uri.dataFromString(url);
          Map<String, String> params = uri.queryParameters;
          if (params == null || params.length <= 0) {
            print(123);
            Global.navigatorKey.currentState.pushNamed(url);
          } else if (params.length == 1 && params.containsKey('id')) {
            var id = params['id'];
            print(456);
            Global.navigatorKey.currentState
                .pushNamed(url.split("?")[0], arguments: id);
          } else {
            print(789);
            Global.navigatorKey.currentState
                .pushNamed(url.split("?")[0], arguments: params);
          }
          break;
        case 3:
          // NavigatorUtil.push(context, VideoPage(linkUrl: url));
          Global.navigatorKey.currentState.pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (BuildContext context) => VideoPage(linkUrl: url)),
              (route) => true);
          break;
      }
    }
  }

//OrderStatus1 int8 = -20 //取消
// OrderStatus2 int8 = -10 //退款
// OrderStatus3 int8 = 0   //未付款
// OrderStatus4 int8 = 10  //代发货
// //OrderStatus5  int8 = 20  //代签收
// OrderStatus6  int8 = 30 //代绑定
// OrderStatus7  int8 = 40 //待回寄
// OrderStatus8  int8 = 50 //待检测
// OrderStatus9  int8 = 60 //待出报告
// OrderStatus10 int8 = 70 //完成

  static String getOrderType(int status) {
    switch (status) {
      case -20:
        return "取消";
      case -10:
        return "退款";
      case 0:
        return "未付款";
      case 10:
        return "待发货";
      case 20:
        return "待签收";
      case 30:
        return "待绑定";
      case 40:
        return "待回寄";
      case 50:
        return "待检测";
      case 60:
      case 70:
        return "待出报告";
      case 80:
        return "完成";
    }
    return "";
  }

  static String getOrderStepType(int status) {
    switch (status) {
      case 20:
        return "物流跟踪";
      case 30:
        return "绑定采集器";
      case 40:
        return "立即回寄";
      case 50:
        return "物流跟踪";
      case 60:
      case 70:
        return "查看示例报告";
      case 80:
        return "查看检测报告";
    }
    return "";
  }

  static var map = {
    -10: OrderStepModel("退款", "", -10),
    10: OrderStepModel("待发货", "", 10),
    20: OrderStepModel("待签收", "物流跟踪", 20),
    30: OrderStepModel("待绑定", "", 30),
    40: OrderStepModel("待回寄", "", 40),
    50: OrderStepModel("待检测", "", 50),
    70: OrderStepModel("待出报告", "", 70),
    80: OrderStepModel("完成", "", 80),
  };

  static var reportMap = {
    30: OrderStepModel("绑定成功", "", 30),
    40: OrderStepModel("待回寄", "立即回寄", 40),
    50: OrderStepModel("收到样本", "物流跟踪", 50),
    // 60: OrderStepModel("待出报告", "查看示例报告", 60),
    80: OrderStepModel("生成报告", "查看报告", 80),
  };

  static Future setCookie(uri1, String token) async {
    if (null != token && token.isNotEmpty) {
      CookieManager cookieManager = CookieManager.instance();
      Cookie cookie =
          await cookieManager.getCookie(url: uri1, name: CommonConstant.JWT);
      if (null != cookie &&
          null != cookie.value &&
          cookie.value.toString().isNotEmpty &&
          cookie.value != token) {
        await cookieManager.deleteCookie(url: uri1, name: CommonConstant.JWT);
      }
      await cookieManager.setCookie(
        url: uri1,
        name: CommonConstant.JWT,
        value: token,
        isSecure: false,
        isHttpOnly: false,
      );
    }
    return Future.value(1);
  }

  static void addJavaScriptHandler(
      InAppWebViewController controller, BuildContext context) {
    controller.addJavaScriptHandler(
        handlerName: "navigate",
        callback: (List<dynamic> args) {
          try {
            print("JavaScriptHandler == navigate");
            if (null != args && args.length >= 2) {
              CommonUtils.toUrl(context: context, url: args[1], type: args[0]);
              if (args[1] == CommonUtils.URL_BUY ||
                  args[1] == CommonUtils.URL_MY ||
                  (args[1].contains(CommonUtils.URL_REPORT) &&
                      !args[1].contains("_"))) {
                Navigator.pop(context);
              }
            }
          } catch (e) {
            print(e);
          }
        });
    controller.addJavaScriptHandler(
        handlerName: "getToken",
        callback: (args) async {
          Uri url = await controller.getUrl();
          if (null != url &&
              null != url.toString() &&
              url.toString().isNotEmpty &&
              url.toString().startsWith(CommonConstant.BASE_API)) {
            return SpUtils().getStorageDefault(SpConstant.Token, "");
          }
          return "";
        });
  }
}
