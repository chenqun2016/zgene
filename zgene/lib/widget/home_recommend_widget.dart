import 'package:flutter/material.dart';

class HomeRecommendWidget extends InheritedWidget {
  HomeRecommendWidget({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);
  final int data; //需要在子树中共享的数据，保存点击次数

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static int of(BuildContext context, {bool listen = true}) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<HomeRecommendWidget>()
        : context
            .getElementForInheritedWidgetOfExactType<HomeRecommendWidget>()
            ?.widget as HomeRecommendWidget;
    return provider.data;
  }

  @override
  bool updateShouldNotify(covariant HomeRecommendWidget old) {
    return old.data != data;
  }
}
