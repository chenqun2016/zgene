import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/bindcollector/qr_scanner_page.dart';
import 'package:zgene/pages/my/my_contant_us.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/base_web.dart';
import 'package:zgene/widget/my_stepper.dart';

class BindCollectorPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _BindCollectorPageState();
  }
}

class _BindCollectorPageState extends BaseWidgetState<BindCollectorPage> {
  var steps = [0, 1, 2];
  int _position = 0;

  //编码文本控制器
  TextEditingController _textEditingController;

  //姓名文本控制器
  TextEditingController _nameEditingController;
  var sex = ['男', '女'];

  //当前选中性别
  var currentSex;

  //当前的生日
  var birthText = "请选择您的生日";
  bool hasBirth = false;

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    backImgPath = "assets/images/mine/img_bg_my.png";
    pageWidgetTitle = "绑定采集器";
    showHead = true;
    customRightBtnText = "采集引导";

    _textEditingController = new TextEditingController();
    _nameEditingController = new TextEditingController();

    currentSex = sex[0];
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _nameEditingController.dispose();
    super.dispose();
  }

  @override
  Future rightBtnTap(BuildContext context) {
    CommonUtils.toCollectionGuide(context);
    return super.rightBtnTap(context);
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          // _titlebar(),
          _stepper(context),
        ],
      ),
    );
  }

  _bindcollector() async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }
    EasyLoading.show(status: 'loading...');

    Map<String, dynamic> map = new HashMap();
    // map['order_id'] = id;
    map['serial_num'] = _textEditingController.text;
    map['target_name'] = _nameEditingController.text;
    map['target_sex'] = currentSex;
    map['target_birthday'] = birthText;
    // map['target_phone'] = "id";

    HttpUtils.requestHttp(
      ApiConstant.bindColector,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (result) async {
        EasyLoading.dismiss();
        setState(() {
          _position++;
        });
      },
      onError: (code, error) {
        EasyLoading.showError(error);
      },
    );
  }

  _getBottomText(position) {
    if (position == steps.length - 1) {
      return "开始采样";
    } else {
      return "下一步";
    }
  }

  _stepper(context) {
    return EStepper(
      stepperWidth: 240,
      showEditingIcon: false,
      currentStep: _position,
      // onStepTapped: (index) {
      //   setState(() {
      //     _position = index;
      //   });
      // },
      // onStepContinue: () {
      //   setState(() {
      //     if (_position < 2) {
      //       _position++;
      //     }
      //   });
      // },
      // onStepCancel: () {
      //   if (_position > 0) {
      //     setState(() {
      //       _position--;
      //     });
      //   }
      // },
      type: EStepperType.horizontal,
      steps: steps.map(
        (s) {
          bool isActive = s == _position;
          return EStep(
            state: _getState(s),
            content: _getContent(s, context),
            isActive: isActive,
          );
        },
      ).toList(),
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Container();
      },
    );
  }

  _getState(index) {
    if (_position == index) return EStepState.editing;
    if (_position > index) return EStepState.complete;
    return EStepState.indexed;
  }

  _getContent(int s, context) {
    if (0 == s) {
      return _bindstep1(context);
    }
    if (1 == s) {
      return _bindstep2;
    }
    if (2 == s) {
      return _bindstep3;
    }
  }

  Widget get _bindstep3 {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(top: 90,bottom: 40),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "恭喜 ${_nameEditingController.text.toString()} 绑定成功！",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.TextMainBlack,
                      ),
                    ),
                    // Container(
                    //   alignment: Alignment.topCenter,
                    //   padding: EdgeInsets.only(top: 20, bottom: 40),
                    //   child: Text.rich(TextSpan(children: [
                    //     TextSpan(
                    //       text: "如果取样完成,可点击此处直接",
                    //       style: TextStyle(
                    //           color: ColorConstant.Text_5E6F88, fontSize: 14),
                    //     ),
                    //     TextSpan(
                    //       text: "《预约上门取件》",
                    //       style: TextStyle(
                    //           color: ColorConstant.TextMainColor, fontSize: 14),
                    //       recognizer: TapGestureRecognizer()..onTap = () {},
                    //     ),
                    //   ])),
                    // ),
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
          Container(
            margin: EdgeInsets.only(top: 30),
            child: MaterialButton(
              height: 55,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27)),
              minWidth: double.infinity,
              disabledColor: Colors.white,
              color: ColorConstant.TextMainColor,
              onPressed: () {
                //绑定成功
                CommonUtils.toCollectionGuide(context,pop: true);
              },
              child: Text(_getBottomText(_position),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget get _bindstep2 {
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
                      controller: _nameEditingController,
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
                          color: ColorConstant.Text_8E9AB,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.TextMainBlack,
                      ),
                      onChanged: (str) {},
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
                    maxDate: PDuration.now(),
                    onConfirm: (p) {
                      setState(() {
                        birthText = "${p.year}-${p.month}-${p.day}";
                      });
                      hasBirth = true;
                      // Navigator.pop(context);
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
                      NavigatorUtil.push(
                          context,
                          BaseWebView(
                            title: "《隐私政策》",
                            url: CommonConstant.privacy,
                          ));
                    },
                ),
              ])),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: MaterialButton(
            height: 55,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
            minWidth: double.infinity,
            disabledColor: Colors.white,
            color: ColorConstant.TextMainColor,
            onPressed: (_nameEditingController.text.isNotEmpty && hasBirth)
                ? () {
                    _bindcollector();
                  }
                : null,
            child: Text(_getBottomText(_position),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: (_nameEditingController.text.isNotEmpty && hasBirth)
                      ? Colors.white
                      : ColorConstant.Divider,
                )),
          ),
        )
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

  Widget _bindstep1(context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            try {
              var code = await NavigatorUtil.push(context, QRViewExample());
              _textEditingController.text = code;
            } catch (e) {
              print(e);
            }
          },
          child: Container(
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
                  onChanged: (str) {},
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
          padding: EdgeInsets.only(top: 20),
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
                  NavigatorUtil.push(context, contantUsPage());
                },
            ),
          ])),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: MaterialButton(
            height: 55,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
            minWidth: double.infinity,
            disabledColor: Colors.white,
            color: ColorConstant.TextMainColor,
            onPressed: _textEditingController.text.isNotEmpty
                ? () {
                    setState(() {
                      _position++;
                    });
                  }
                : null,
            child: Text(_getBottomText(_position),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _textEditingController.text.isNotEmpty
                      ? Colors.white
                      : ColorConstant.Divider,
                )),
          ),
        )
      ],
    );
  }
}
