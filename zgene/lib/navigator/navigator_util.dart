import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//统一页面跳转工具类
class NavigatorUtil {
  ///跳转到指定页面
  static Future push(BuildContext context, Widget page) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
