import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/ui_uitls.dart';

class BindStep1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BindStep1State();
  }
}

class _BindStep1State extends State<BindStep1> {
  //文本控制器
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 0),
          padding: EdgeInsets.only(top: 0, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Image.asset(
                "assets/images/home/icon_saoma.png",
                height: 110,
                width: 110,
              ),
              Text(
                "扫一扫采集器上的条形码",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.TextMainBlack,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "如无法扫码可以手动输入采集器编号",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.Text_5E6F88,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Divider(
                  height: 1,
                  color: ColorConstant.Divider,
                ),
              ),
              Image.asset(
                "assets/images/home/img_shili.png",
                height: 65,
                width: 149,
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/home/icon_shuru.png",
                height: 20,
                width: 20,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: _textEditingController,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: "手动输入编号",
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: ColorConstant.Text_5E6F88,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextMainBlack,
                  ),
                  onSubmitted: (value) {
                    // _onTapEvent(2);
                  },
                  // autocorrect: true,
                  // autofocus: true,
                ),
              )),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 20, bottom: 40),
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: "如果绑定失败，请点击",
              style: TextStyle(color: ColorConstant.Text_5E6F88, fontSize: 14),
            ),
            TextSpan(
              text: "联系客服",
              style:
                  TextStyle(color: ColorConstant.TextMainColor, fontSize: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _onTextTap();
                },
            ),
          ])),
        ),
      ],
    );
  }

  _onTextTap() {
    UiUitls.showToast("联系客服");
  }
}
