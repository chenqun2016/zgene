import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/ui_uitls.dart';

class BindStep2 extends StatefulWidget {
  var onChangeNextButtomState;

  BindStep2(Function(bool canNext) onChangeNextButtomState) {
    this.onChangeNextButtomState = onChangeNextButtomState;
  }

  @override
  State<StatefulWidget> createState() {
    return _BindStep2State();
  }
}

class _BindStep2State extends State<BindStep2> {
  bool _checkbox1Selected = true;
  var sex = ['男', '女'];
  var currentSex;

  var birthText = "请选择您的生日";

  bool hasName;
  bool hasBirth;

  @override
  void initState() {
    super.initState();
    currentSex = sex[0];
  }

  _onTapDown() {
    print("onTapDown");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 0),
          // padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _leftText("姓名"),
                    Expanded(
                        child: TextField(
                      keyboardType: TextInputType.multiline,
                      // controller: _textEditingController,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: "检测对象",
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: ColorConstant.Text_5E6F88,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.TextMainBlack,
                      ),
                      onChanged: (str) {
                        hasName = str.isNotEmpty;
                        widget.onChangeNextButtomState(hasName && hasBirth);
                      },
                      // autocorrect: true,
                      // autofocus: true,
                    )),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: ColorConstant.Divider,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _leftText("性别")),
                    Radio(
                      activeColor: ColorConstant.TextMainColor,
                      value: sex[0],
                      groupValue: currentSex,
                      onChanged: (value) {
                        setState(() {
                          currentSex = value;
                        });
                      },
                    ),
                    Text(
                      sex[0],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: sex.indexOf(currentSex) == 0
                            ? ColorConstant.TextMainColor
                            : ColorConstant.Text_5E6F88,
                      ),
                    ),
                    Radio(
                      activeColor: ColorConstant.TextMainColor,
                      value: sex[1],
                      groupValue: currentSex,
                      onChanged: (value) {
                        setState(() {
                          currentSex = value;
                        });
                      },
                    ),
                    Text(
                      sex[1],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: sex.indexOf(currentSex) == 1
                            ? ColorConstant.TextMainColor
                            : ColorConstant.Text_5E6F88,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: ColorConstant.Divider,
              ),
              GestureDetector(
                onTap: () async {
                  Pickers.showDatePicker(
                    context,
                    onConfirm: (p) {
                      setState(() {
                        birthText = "${p.year} / ${p.month} / ${p.day}";
                      });
                      hasBirth = true;
                      Navigator.pop(context);
                      widget.onChangeNextButtomState(hasName && hasBirth);
                    },
                    // onChanged: (p) => print(p),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _leftText("生日")),
                      Text(
                        birthText,
                        style: TextStyle(
                          fontSize: 15,
                          color: ColorConstant.Text_9395A4,
                        ),
                      ),
                      Image(
                        image:
                            AssetImage("assets/images/mine/icon_my_right.png"),
                        height: 16,
                        width: 16,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 20),
          child: RichText(
              text: TextSpan(
                  text: "注:关于用户隐私安全保护请详细解读",
                  style:
                      TextStyle(color: ColorConstant.Text_5E6F88, fontSize: 14),
                  children: [
                TextSpan(
                  text: "《隐私政策》",
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
    );
  }

  _leftText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: ColorConstant.TextMainBlack,
      ),
    );
  }

  _onTextTap() {
    UiUitls.showToast("联系客服");
  }

  _showDatePicker(context) async {
    var first = DateTime(1900);
    var date = DateTime.now();
    date.add(Duration());
    return await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: first,
      lastDate: date,
    );
  }
}
