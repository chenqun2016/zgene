import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

class ProblemNav extends StatefulWidget {
  @override
  _ProblemNavState createState() => _ProblemNavState();
}

class _ProblemNavState extends State<ProblemNav> {
  // List<String> contents = ["关于基因检测。？", "基因检测的原理是什么？", "对用户隐私安全有什么保护措施？"];

  List contentList = [];

  @override
  void initState() {
    super.initState();
    HomeGetHttp(3, (result) {
      print(result);
      ContentModel contentModel = ContentModel.fromJson(result);
      contentList.clear();
      setState(() {
        contentList = contentModel.archives;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "常见问题",
            style: TextStyle(
                fontSize: 18,
                color: ColorConstant.TextMainBlack,
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 40),
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(children: _items()),
          ),
        ],
      ),
    );
  }

  List<Widget> _items() {
    List<Widget> items = [];
    contentList.forEach((element) {
      if (contentList.indexOf(element) != 0) {
        items.add(Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Divider(),
        ));
      }

      items.add(_item(element.title));
    });
    return items;
  }

  Widget _item(contents) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                contents,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    color: ColorConstant.TextMainBlack,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Image.asset(
              "assets/images/home/icon_to.png",
              height: 20,
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
