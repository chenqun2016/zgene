import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//统一页面跳转工具类
class NavigatorUtil {
  ///跳转到指定页面
  static push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  ///跳转到指定页面
  static pushAndRemoveUntil(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => page), (rout) => rout == null);
  }
}
