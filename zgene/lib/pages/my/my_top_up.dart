import 'package:zgene/constant/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class myTopUp extends StatefulWidget {
  myTopUp({Key key}) : super(key: key);

  @override
  _myTopUpState createState() => _myTopUpState();
}

class _myTopUpState extends State<myTopUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.WhiteColor,
        brightness: Brightness.light,
        leading: IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/mine/icon_mine_backArrow.png"),
            size: 16,
            color: ColorConstant.MainBlack,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: Text(
          "设置",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: ColorConstant.MainBlack),
        ),
      ),
      // body: WebView(
      //   initialUrl: "https://flutterchina.club/",
      //   //JS执行模式 是否允许JS执行
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
    );
  }
}
