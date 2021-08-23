

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/navigator/navigator_util.dart';

import 'down_push_content_view.dart';
import 'set_password.dart';

////密保找回
// ignore: camel_case_types
class encrytedFindPage extends StatefulWidget {
  String accountStr;

  encrytedFindPage({Key key, this.accountStr}) : super(key: key);

  @override
  _encrytedFindPageState createState() => _encrytedFindPageState();
}

class _encrytedFindPageState extends State<encrytedFindPage> {
  String _paswordErrorStr = null;
  String _confirmPasswordErrorStr = null;

  String _passwordText = "";
  String _confirmPasswordText = "";
  Color _encryBorderColor = ColorConstant.LineMainColor;

  TextEditingController _controller = TextEditingController();

  List questionArray = [];
  List questionDicArray = [];
  int selectId = -1;
  String _encryptedStr = "";

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  getHttp() {
    EasyLoading.show(status: 'loading...');

    // Map<String, dynamic> map = new HashMap();
    HttpUtils.requestHttp(
      ApiConstant.securityQuestion,
      // parameters: map,
      method: HttpUtils.GET,
      onSuccess: (data) {
        EasyLoading.dismiss();
        print(data.toString());
        questionDicArray = data["items"] ?? [];
        questionArray = [];
        for (var item in questionDicArray) {
          questionArray.add(item["question"]);
        }

        setState(() {});
      },
      onError: (code, error) {
        EasyLoading.dismiss();
        print(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorConstant.WhiteColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      top: 53,
                    ),
                    width: 32,
                    height: 16,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        // NavigatorUtils.goBack(context);
                        Navigator.pop(context);
                      },
                      icon: ImageIcon(
                        AssetImage(
                            "assets/images/mine/icon_mine_backArrow.png"),
                        size: 16,
                        color: ColorConstant.MainBlack,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 36,
                  left: 33,
                ),
                child: Text(
                  "密保找回",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextMainColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 74, left: 32, right: 32),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  //设置四周圆角 角度
                  //设置四周边框
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: new Border.all(width: 1, color: _encryBorderColor),
                ),
                child: ContentView.dropdownView(
                  controller: _controller,
                  contentList: questionArray.toSet().toList(),
                  hintText: '请选择一个密保问题',
                  onChanged: (title) {
                    _encryptedStr = title;
                    for (var item in questionDicArray) {
                      if (title == item["question"]) {
                        selectId = item["id"];
                        break;
                      }
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                  left: 33,
                  right: 33,
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _confirmPasswordText = value;
                  },
                  decoration: InputDecoration(
                    labelText: "请输入答案",
                    errorText: _confirmPasswordErrorStr,
                    enabledBorder: new UnderlineInputBorder(
                      // 不是焦点的时候颜色
                      borderSide:
                      BorderSide(color: ColorConstant.LineMainColor),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.TextSecondColor,
                    ),
                  ),
                  // inputFormatters: [LengthLimitingTextInputFormatter(6)],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 27, left: 33),
                  height: 45,
                  width: MediaQuery.of(context).size.width - 66,
                  child: TextButton(
                    onPressed: () {
                      loginBtnAction();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0)),
                        ),
                        backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                          return Color(CommonConstant.THEME_COLOR);
                        })),
                    child: Text(
                      "下一步",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.WhiteColor),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void loginBtnAction() {
    if (_encryptedStr == "") {
      _encryBorderColor = Colors.red;
    } else {
      _encryBorderColor = ColorConstant.LineMainColor;
    }

    if (_confirmPasswordText == "") {
      _confirmPasswordErrorStr = "请输入答案";
    } else {
      _confirmPasswordErrorStr = null;
    }

    if (_confirmPasswordText != "" && selectId != -1) {
      _encryBorderColor = ColorConstant.LineMainColor;
      _confirmPasswordErrorStr = null;

      Map<String, dynamic> map = new HashMap();
      map["sq_id"] = selectId;
      map["sq_answer"] = _confirmPasswordText;
      map["username"] = widget.accountStr;

      EasyLoading.show(status: 'loading...');
      HttpUtils.requestHttp(
        ApiConstant.checkSq_answer,
        parameters: map,
        method: HttpUtils.POST,
        onSuccess: (data) {
          EasyLoading.dismiss();
          NavigatorUtil.push(context, setPasswordPage(
            accountStr: widget.accountStr,
            sqId: selectId,
            sqAnswer: _confirmPasswordText,
          ));
        },
        onError: (code, error) {
          EasyLoading.showError(error ?? "");
        },
      );
    }
    setState(() {});
  }
}