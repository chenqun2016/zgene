import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/order_step_model.dart';
import 'package:zgene/util/base_widget.dart';
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
    showHead = false;
    isListPage = true;
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
  Widget viewPageBody(BuildContext context) {
    return ListView(
      children: [
        _titlebar(),
        _orderDetail(),
        _orderStepper(),
      ],
    );
  }

  _titlebar() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 48, left: 15, right: 15),
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
            "订单流程",
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
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ))
        ],
      ),
    );
  }

  _orderDetail() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
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

  _orderStepper() {
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
            title: _getTitleContent(s),
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

  _getTitleContent(model) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 64,
      padding: EdgeInsets.only(left: 15, right: 15),
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
      child: Row(children: [
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
        getRightButton(model),
      ]),
    );
  }

  _isAchieve(model) {
    return steps.indexOf(model) <= _position;
  }

  getRightButton(model) {
    return MaterialButton(
      height: 39,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
      disabledColor: Colors.white,
      color: ColorConstant.TextMainColor,
      onPressed: _isAchieve(model) ? () {} : null,
      child: Text(model.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _isAchieve(model) ? Colors.white : ColorConstant.Text_B2BAC6,
          )),
    );
  }
}