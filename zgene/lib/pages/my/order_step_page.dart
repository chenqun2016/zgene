import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/models/order_list_model.dart';
import 'package:zgene/models/order_step_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/bindcollector/bind_collector_page.dart';
import 'package:zgene/pages/my/my_report_page.dart';
import 'package:zgene/pages/my/order_detail.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/base_web.dart';
import 'package:zgene/widget/my_stepper.dart';

import '../splash_page.dart';
import 'sendBack_acquisition.dart';

class OrderStepPage extends BaseWidget {
  OrderListmodel _order;

  OrderStepPage({order}) {
    _order = order;
  }

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _OrderStepPageState();
  }
}

class _OrderStepPageState extends BaseWidgetState<OrderStepPage> {
  List steps;
  int _position = 0;
  var stepMap = {
    10: OrderStepModel("待发货", "", 10),
    20: OrderStepModel("待签收", "物流跟踪", 20),
    30: OrderStepModel("待绑定", "绑定采集器", 30),
    40: OrderStepModel("待回寄", "立即回寄", 40),
    50: OrderStepModel("待检测", "物流跟踪", 50),
    60: OrderStepModel("待出报告", "查看示例报告", 60),
    70: OrderStepModel("完成", "查看检测报告", 70),
  };

  @override
  void pageWidgetInitState() {
    customRightBtnText = "采集引导";
    pageWidgetTitle = "订单流程";
    backImgPath = "assets/images/mine/img_bg_my.png";
    isListPage = true;

    steps = stepMap.values.toList();
    if (null != widget._order) {
      if (widget._order.status < 10) {
        _position = 0;
      } else if (widget._order.status > 70) {
        _position = steps.length - 1;
      } else {
        _position = stepMap.keys.toList().indexOf(widget._order.status);
      }
    }
    super.pageWidgetInitState();
  }

  @override
  rightBtnTap(BuildContext context) {
    UiUitls.showToast("采集引导");
  }

  @override
  Widget viewPageBody(BuildContext context) {
    if (null != widget._order) return _orderStepper(context);
  }

  _orderStepper(context) {
    return EStepper(
      physics: BouncingScrollPhysics(),
      showcompleteIcon: false,
      showEditingIcon: false,
      isVerticalAnimatedCrossFade: false,
      stepperWidth: 240,
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
              model.title,
              style: TextStyle(
                color: _isAchieve(model)
                    ? ColorConstant.TextMainBlack
                    : ColorConstant.Text_B2BAC6,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )),
            getRightButton(model, context),
          ]),
          //TODO 条件更换
          if (model.status == 60 && _isButtomAchieve(model))
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

  _isButtomAchieve(model) {
    return steps.indexOf(model) == _position;
  }

  getRightButton(model, context) {
    if (model.status == 10) {
      return GestureDetector(
        onTap: () {
          NavigatorUtil.push(context, OrderDetailPage(order: widget._order));
        },
        child: Container(
          height: 50,
          width: 200,
          color: Colors.transparent,
          alignment: Alignment.centerRight,
          child: Image.asset(
            "assets/images/home/icon_to.png",
            height: 50,
            width: 16,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }
    return MaterialButton(
      height: 39,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
      disabledColor: Colors.white,
      color: ColorConstant.TextMainColor,
      onPressed: _isButtomAchieve(model)
          ? () async {
              onButtomClicked(context, model);
            }
          : null,
      child: Text(model.title2,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _isButtomAchieve(model)
                ? Colors.white
                : ColorConstant.Text_B2BAC6,
          )),
    );
  }

// //OrderStatus5  int8 = 20  //代签收
// OrderStatus6  int8 = 30 //代绑定
// OrderStatus7  int8 = 40 //待回寄
// OrderStatus8  int8 = 50 //待检测
// OrderStatus9  int8 = 60 //待出报告
// OrderStatus10 int8 = 70 //完成
  void onButtomClicked(context, model) {
    switch (model.status) {
      case 50:
        NavigatorUtil.push(
            context,
            BaseWebView(
              url: ApiConstant.getSFH5DetailUrl(widget._order.reSfNo),
            ));
        break;
      case 20:
        NavigatorUtil.push(
            context,
            BaseWebView(
              url: ApiConstant.getSFH5DetailUrl(widget._order.sfNo),
            ));
        break;
      case 30:
        NavigatorUtil.push(context, BindCollectorPage());
        break;
      case 40:
        NavigatorUtil.push(context, SendBackAcquisitionPage());
        break;
      case 60:
        CommonUtils.toUrl(context: context, url: CommonUtils.URL_REPORT);
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case 70:
        NavigatorUtil.push(context, MyReportPage());
        break;
    }
  }
}
