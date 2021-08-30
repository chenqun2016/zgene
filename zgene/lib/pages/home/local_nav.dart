import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/bindcollector/bind_collector_page.dart';
import 'package:zgene/pages/my/order_step_page.dart';

class LocalNav extends StatelessWidget {
  List<String> localNavList = ["绑定采集器", "如何检测", "基因报告", "阅读指南"];
  List<String> localNavIcon = [
    "assets/images/home/icon_bangding.png",
    "assets/images/home/icon_jiyinbaogao.png",
    "assets/images/home/icon_ruhejiance.png",
    "assets/images/home/icon_yueduzhinan.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16,left: 15,right: 15),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: _items(context),
    );
  }

  _items(BuildContext context) {
    if (localNavList == null) return null;
    List<Widget> items = [];

    localNavList.forEach((model) {
      items.add(_item(context, model, localNavList.indexOf(model)));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  Widget _item(BuildContext context, String title, int index) {
    return GestureDetector(
      onTap: () {
        if (0 == index) {
          NavigatorUtil.push(context, BindCollectorPage());
        }
        if (1 == index) {
          NavigatorUtil.push(context, OrderStepPage());
        }
      },
      child: Column(
        children: <Widget>[
          Image.asset(
            localNavIcon[index],
            width: 80,
            height: 80,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 13, color: ColorConstant.TextMainBlack),
          )
        ],
      ),
    );
  }
}
