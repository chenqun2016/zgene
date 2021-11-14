import 'package:flutter/material.dart';

///状态管理
class MyInheritedWidget extends InheritedWidget {
  MyInheritedWidget({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);
  final dynamic data; //需要在子树中共享的数据，保存点击次数

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static dynamic of(BuildContext context, {bool listen = true}) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()
        : context
            .getElementForInheritedWidgetOfExactType<MyInheritedWidget>()
            ?.widget as MyInheritedWidget;
    return provider?.data;
  }

  @override
  bool updateShouldNotify(covariant dynamic old) {
    return old.data != data;
  }
}
