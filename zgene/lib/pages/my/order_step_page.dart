import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/order_step_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/my_stepper.dart';

class OrderStepPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return _OrderStepPageState();
  }
}

class _OrderStepPageState extends BaseWidgetState<OrderStepPage> {
  @override
  void pageWidgetInitState() {
    customRightBtnText = "采集引导";
    pageWidgetTitle = "订单流程";
    backImgPath = "assets/images/mine/img_bg_my.png";
    steps = [
      OrderStepModel("待发货", 1),
      OrderStepModel("已发货", 2),
      OrderStepModel("待签收", 3),
      OrderStepModel("已签收", 4),
      OrderStepModel("采集器绑定成功", 5),
      OrderStepModel("待发货", 6),
      OrderStepModel("待发货", 7),
      OrderStepModel("待发货", 8),
      OrderStepModel("待发货1", 9),
      OrderStepModel("待发货1", 0)
    ];
    super.pageWidgetInitState();
  }

  @override
  rightBtnTap(BuildContext context) {
    UiUitls.showToast("采集引导");
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Column(
      children: [
        _orderDetail(),
        _orderStepper(context),
      ],
    );
  }

  _orderDetail() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        padding: EdgeInsets.fromLTRB(4, 8, 15, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/images/mine/img_dingdanxiangqing.png",
              height: 78,
              width: 78,
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "订单详情",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.TextMainBlack,
                        ),
                      ),
                      Text(
                        "16299628c418d7ae",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.Text_5E6F88,
                        ),
                      )
                    ],
                  ),
                )),
            Image(
              image: AssetImage("assets/images/mine/icon_my_right.png"),
              height: 16,
              width: 16,
            )
          ],
        ),
      ),
    );
  }

  List steps;
  int _position = 0;

  _orderStepper(context) {
    return EStepper(
      physics: BouncingScrollPhysics(),
      showcompleteIcon: false,
      showEditingIcon: false,
      isVerticalAnimatedCrossFade: false,
      stepperWidth: 240,
      currentStep: _position,
      onStepTapped: (index) {
        setState(() {
          _position = index;
        });
      },
      onStepContinue: () {
        setState(() {
          if (_position < 2) {
            _position++;
          }
        });
      },
      onStepCancel: () {
        if (_position > 0) {
          setState(() {
            _position--;
          });
        }
      },
      type: EStepperType.vertical,
      steps: steps.map(
        (s) {
          bool isActive = steps.indexOf(s) == _position;
          return EStep(
            title: _getTitleContent(s, context),
            state: _getState(s),
            content: Text(""),
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

  _getState(model) {
    if (_position == steps.indexOf(model)) return EStepState.editing;
    if (_position > steps.indexOf(model)) return EStepState.complete;
    return EStepState.indexed;
  }

  _getTitleContent(model, context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            Expanded(
                child: Text(
              model.name,
              style: TextStyle(
                color: _isAchieve(model)
                    ? ColorConstant.TextMainBlack
                    : ColorConstant.Text_B2BAC6,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )),
            getRightButton(model, context),
          ]),
          //TODO 条件更换
          if (steps.indexOf(model) == 1)
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
              decoration: BoxDecoration(
                color: ColorConstant.Text_5FC88F_10per,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Text(
                "您的样本正在检测中，基因报告约在15天完成",
                style: TextStyle(
                  color: ColorConstant.Text_5FC88F,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  _isAchieve(model) {
    return steps.indexOf(model) <= _position;
  }

  getRightButton(model, context) {
    return MaterialButton(
      height: 39,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
      disabledColor: Colors.white,
      color: ColorConstant.TextMainColor,
      onPressed: _isAchieve(model)
          ? () async {
              bool qianshou = await _showMyDialog(context);
              if (qianshou) {
                UiUitls.showToast("签收");
              }
            }
          : null,
      child: Text(model.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _isAchieve(model) ? Colors.white : ColorConstant.Text_B2BAC6,
          )),
    );
  }

  _showMyDialog(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SafeArea(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                      height: 230,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(top: 90),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "确认签收？",
                            style: TextStyle(
                              color: ColorConstant.TextMainBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MaterialButton(
                                  minWidth: 120,
                                  height: 50,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: ColorConstant.TextMainColor),
                                      borderRadius: BorderRadius.circular(25)),
                                  color: ColorConstant.WhiteColor,
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text("取消",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstant.TextMainColor,
                                      )),
                                ),
                                MaterialButton(
                                  minWidth: 120,
                                  height: 50,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  color: ColorConstant.TextMainColor,
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text("确认",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  Image.asset(
                    "assets/images/mine/img_chenggong.png",
                    height: 110,
                    width: 110,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
