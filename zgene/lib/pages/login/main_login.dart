import 'package:zgene/util/base_widget.dart';

import 'package:flutter/material.dart';

class MainLoginPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _MainLoginPageState();
  }
}

class _MainLoginPageState extends BaseWidgetState<MainLoginPage> {
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = true;
    backImgPath = "assets/images/login/icon_mainLogin_backImg.png";
  }

  @override
  Widget viewPageBody() {
    // 当前widget的具体内容
    return Container(
      child: Text("123123123123"),
    );
  }

  @override
  Future myBackClick() {
    Navigator.pop(context);
  }
}
