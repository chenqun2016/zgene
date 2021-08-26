import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';

class BindCollectorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BindCollectorPageState();
  }
}

class _BindCollectorPageState extends State<BindCollectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mine/img_bg_my.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titlebar(),

          ],
        ),
      ),
    );
  }

  _titlebar() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 48),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image(
              image: AssetImage("assets/images/mine/icon_back.png"),
              height: 40,
              width: 40,
            ),
          ),
          Center(
              child: Text(
            "绑定采集器",
            style: TextStyle(
              color: ColorConstant.TextMainBlack,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )),
          Positioned(
              right: 0,
              child: Text(
                "采集引导",
                style: TextStyle(
                  color: ColorConstant.TextMainBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ))
        ],
      ),
    );
  }
}
