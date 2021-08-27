import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/ui_uitls.dart';

class BindStep3 extends StatefulWidget {
  var name = "陈陈";

  @override
  State<StatefulWidget> createState() {
    return _BindStep3State();
  }
}

class _BindStep3State extends State<BindStep3> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.only(top: 90),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "恭喜 ${widget.name} 绑定成功！",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.TextMainBlack,
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 20, bottom: 40),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "如果取样完成,可点击此处直接",
                      style: TextStyle(
                          color: ColorConstant.Text_5E6F88, fontSize: 14),
                    ),
                    TextSpan(
                      text: "《预约上门取件》",
                      style: TextStyle(
                          color: ColorConstant.TextMainColor, fontSize: 14),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _onTextTap();
                        },
                    ),
                  ])),
                ),
              ],
            ),
          ),
          Center(
            child: Image.asset(
              "assets/images/home/img_chenggong.png",
              height: 116,
              width: 116,
            ),
          )
        ],
      ),
    );
  }

  _onTextTap() {
    UiUitls.showToast("预约上门取件");
  }
}
