import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/pages/my/my_report_page.dart';
import 'package:zgene/pages/my/sendBack_acquisition.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/widget/base_web.dart';

//统一页面跳转工具类
class NavigatorUtil {
  ///跳转到指定页面
  static Future<dynamic> push(BuildContext context, Widget page) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static Future<dynamic> popAndPushNamed(BuildContext context, String name) {
    return Navigator.popAndPushNamed(context, name);
  }

  static Future<dynamic> pushAndRemoveUntil(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page),
        (route) => route.isFirst);
  }

// //OrderStatus5  int8 = 20  //代签收
// OrderStatus6  int8 = 30 //代绑定
// OrderStatus7  int8 = 40 //待回寄
// OrderStatus8  int8 = 50 //待检测
// OrderStatus9  int8 = 60 //待出报告
// OrderStatus10 int8 = 70 //完成
  static Future<dynamic> orderStepNavigator(context, status, _order) {
    switch (status) {
      case 50:
        return NavigatorUtil.push(
            context,
            BaseWebView(
              url: ApiConstant.getSFH5DetailUrl(_order.reSfNo),
              title: "物流跟踪",
              isShare: false,
            ));
      case 30:
      case 20:
        return NavigatorUtil.push(
            context,
            BaseWebView(
              url: ApiConstant.getSFH5DetailUrl(_order.sfNo),
              title: "物流跟踪",
              isShare: false,
            ));
      // case 30:
      //   return NavigatorUtil.push(context, QRScannerView());
      case 40:
        print(123);
        if (null != _order.collectorInfo) {
          return NavigatorUtil.push(
              context,
              SendBackAcquisitionPage(
                  ordId: _order.id,
                  ordName: _order.collectorInfo.targetName,
                  ordNum: _order.collectorInfo.serialNum));
        }
        break;
      case 70:
        CommonUtils.toUrl(context: context, url: CommonUtils.URL_REPORT);
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case 80:
        return NavigatorUtil.push(context, MyReportPage());
    }
    return Future(() => 0);
  }
}
