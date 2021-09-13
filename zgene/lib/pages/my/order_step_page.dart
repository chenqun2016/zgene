import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/order_list_model.dart';
import 'package:zgene/models/order_step_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/refresh_config_utils.dart';
import 'package:zgene/widget/my_stepper.dart';

class OrderStepPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return _OrderStepPageState();
  }
}

class _OrderStepPageState extends BaseWidgetState<OrderStepPage> {
  OrderListmodel order;
  EasyRefreshController _easyController;
  List steps;
  int _position = 0;
  var orderId = "";

  Map stepMap = Map();

  @override
  void pageWidgetInitState() {
    customRightBtnText = "采集引导";
    pageWidgetTitle = "订单流程";
    backImgPath = "assets/images/mine/img_bg_my.png";
    isListPage = true;

    _easyController = EasyRefreshController();
    _initCurrentPosition();
    super.pageWidgetInitState();
  }

  void _initCurrentPosition() {
    if (null != order) {
      if (order.status == -10) {
        stepMap.addAll(CommonUtils.map);
        _position = 0;
      } else {
        stepMap.addAll(CommonUtils.map);
        stepMap.remove(-10);
        if (order.status < 10) {
          _position = 0;
        } else if (order.status > 70) {
          _position = steps.length - 1;
        } else {
          _position = stepMap.keys.toList().indexOf(order.status);
        }
      }
      steps = stepMap.values.toList();
      print("_initCurrentPosition/${order.status}/" + stepMap.toString());
    }
  }

  @override
  rightBtnTap(BuildContext context) {
    CommonUtils.toCollectionGuide(context);
  }

  @override
  Widget viewPageBody(BuildContext context) {
    //获取路由传的参数
    orderId = ModalRoute.of(context).settings.arguments;
    return EasyRefresh(
      // 是否开启控制结束加载
      enableControlFinishLoad: false,
      firstRefresh: true,
      // 控制器
      controller: _easyController,
      header: RefreshConfigUtils.classicalHeader(),
      child: order != null ? _orderStepper(context) : Text(""),
      //下拉刷新事件回调
      onRefresh: () async {
        getHttp();
        if (_easyController != null) {
          _easyController.resetLoadState();
        }
      },
    );
  }

  getHttp() async {
    Map<String, dynamic> map = new HashMap();
    map["order_id"] = orderId;
    HttpUtils.requestHttp(
      ApiConstant.orderDetail,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (data) {
        print(data);
        OrderListmodel orderModel = OrderListmodel.fromJson(data);
        order = orderModel;
        _initCurrentPosition();
        setState(() {});
      },
      onError: (code, error) {},
    );
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
          bool isActive = (steps.indexOf(s) == _position);
          if (order.status < 0) {
            isActive = false;
          }
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
                color: _isActive(model)
                    ? ColorConstant.TextMainBlack
                    : ColorConstant.Text_B2BAC6,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )),
            getRightButton(model, context),
          ]),
          //TODO 条件更换
          if (model.status == 60 && _isButtomActive(model))
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

  _isActive(model) {
    return steps.indexOf(model) <= _position;
  }

  _isButtomActive(model) {
    return steps.indexOf(model) == _position;
  }

  getRightButton(model, context) {
    if (model.status <= 10) {
      if (_isButtomActive(model))
        return GestureDetector(
          onTap: () {
            _isButtomActive(model)
                ? Navigator.of(context)
                    .pushNamed("/order_detail", arguments: order.id.toString())
                : null;
          },
          child: Container(
            height: 50,
            width: 100,
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
      else
        return Container(
          height: 50,
        );
    }
    return MaterialButton(
      height: 39,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
      disabledColor: Colors.white,
      color: ColorConstant.TextMainColor,
      onPressed: _isButtomActive(model)
          ? () async {
              await NavigatorUtil.orderStepNavigator(
                  context, model.status, order);
              getHttp();
            }
          : null,
      child: Text(model.title2,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _isButtomActive(model)
                ? Colors.white
                : ColorConstant.Text_B2BAC6,
          )),
    );
  }
}
