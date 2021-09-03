import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/msg_event.dart';
import 'package:zgene/pages/tabs/buy_page.dart';
import 'package:zgene/pages/tabs/home_page.dart';
import 'package:zgene/pages/tabs/my_page.dart';
import 'package:zgene/pages/tabs/report_page.dart';
import 'package:zgene/util/common_utils.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = ColorConstant.TextMainGray;
  final _activeColor = ColorConstant.TextMainColor;
  int _currentIndex = 0;
  final eventBus = CommonUtils.getInstance();
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    // 监听数据变化
    eventBus.on<MsgEvent>().listen((event) {
      switch (event.type) {
        case 100: //切换tab
          _controller.jumpToPage(event.msg);
          setState(() {
            _currentIndex = event.msg;
          });
          break;
      }
    });
  }

  /// extendBody = true 凹嵌透明，需要处理底部 边距
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: _controller,
        children: <Widget>[
          HomePage(),
          BuyPage(),
          ReportPage(),
          MyPage(),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: PhysicalModel(
        shape: BoxShape.rectangle,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        shadowColor: Colors.black,
        elevation: 20,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: SafeArea(
          child: Container(
            color: Colors.transparent,
            height: 66,
            child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                unselectedFontSize: 12,
                selectedFontSize: 14,
                iconSize: 26,
                currentIndex: _currentIndex,
                onTap: (index) {
                  _controller.jumpToPage(index);
                  setState(() {
                    _currentIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                items: [
                  _bottomItem(
                      '首页',
                      Image.asset("assets/images/tabs/tab_home_n.png",
                          height: 26, width: 26),
                      Image.asset("assets/images/tabs/tab_home_y.png",
                          height: 26, width: 26),
                      0),
                  _bottomItem(
                      '购买',
                      Image.asset("assets/images/tabs/tab_buy_n.png",
                          height: 26, width: 26),
                      Image.asset("assets/images/tabs/tab_buy_y.png",
                          height: 26, width: 26),
                      1),
                  _bottomItem(
                      '报告',
                      Image.asset("assets/images/tabs/tab_report_n.png",
                          height: 26, width: 26),
                      Image.asset("assets/images/tabs/tab_report_y.png",
                          height: 26, width: 26),
                      2),
                  _bottomItem(
                      '我的',
                      Image.asset("assets/images/tabs/tab_mine_n.png",
                          height: 26, width: 26),
                      Image.asset("assets/images/tabs/tab_mine_y.png",
                          height: 26, width: 26),
                      3),
                ]),
          ),
        ),
      ),
    );
  }

  _bottomItem(String title, Widget icon, Widget iconSelected, int index) {
    return BottomNavigationBarItem(
        icon: icon,
        activeIcon: iconSelected,
        // label: title,
        title: Text(
          title,
          style: TextStyle(
              color: _currentIndex != index ? _defaultColor : _activeColor),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    eventBus.destroy();
  }
}
