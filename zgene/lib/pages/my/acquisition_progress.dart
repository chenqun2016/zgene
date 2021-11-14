import 'dart:collection';

import 'package:base/constant/color_constant.dart';
import 'package:base/http/http_utils.dart';
import 'package:base/navigator/navigator_util.dart';
import 'package:base/widget/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/models/report_detail_model.dart';
import 'package:zgene/pages/my/sendBack_acquisition.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/widget/base_web.dart';
import 'package:zgene/widget/my_stepper.dart';

class acqusitionProgressPage extends StatefulWidget {
  int id;
  String title;

  acqusitionProgressPage({Key key, this.id, this.title}) : super(key: key);

  @override
  BaseWidgetState createState() {
    return _OacqusitionProgressPageState();
  }
}

class _OacqusitionProgressPageState
    extends BaseWidgetState<acqusitionProgressPage> {
  ReportDetailModel order;
  EasyRefreshController _easyController;
  List steps;
  int _position = 0;
  // int Id = 0;

  Map stepMap = Map();

  @override
  void customInitState() {
    customRightBtnText = "采集引导";
    pageWidgetTitle = widget.title;
    backImgPath = "assets/images/mine/img_bg_my.png";
    isListPage = true;
    _easyController = EasyRefreshController();
    _initCurrentPosition();
    super.customInitState();
    // bus.on(CommonConstant.refreshACPross, (arg) {
    //   getHttp();
    //   _easyController.resetLoadState();
    // });
  }

  @override
  void dispose() {
    super.dispose();

    // eventBus.destroy();
    // bus.off(CommonConstant.refreshACPross);
  }

  void _initCurrentPosition() {
    stepMap.clear();
    if (null != order) {
      // if (order.status == 30) {
      //   stepMap.addAll(CommonUtils.reportMap);
      //   _position = 0;
      //   steps = stepMap.values.toList();
      // } else {
      stepMap.addAll(CommonUtils.reportMap);
      steps = stepMap.values.toList();
      if (order.status <= 30) {
        _position = 0;
      } else if (order.status <= 70 && order.status >= 50) {
        _position = 2;
      } else if (order.status == 80) {
        _position = 3;
      } else {
        _position = stepMap.keys.toList().indexOf(order.status);
      }
      // }

    }
  }

  @override
  customRightBtnTap(BuildContext context) {
    CommonUtils.toCollectionGuide(context);
  }

  @override
  Widget customBuildBody(BuildContext context) {
    //获取路由传的参数
    return EasyRefresh(
      // 是否开启控制结束加载
      enableControlFinishLoad: false,
      firstRefresh: true,
      // 控制器
      controller: _easyController,
      header: BallPulseHeader(),
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
    map["id"] = widget.id;
    HttpUtils.requestHttp(
      ApiConstant.collector_detail,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (data) {
        print(data);
        ReportDetailModel orderModel = ReportDetailModel.fromJson(data);
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
      controlsBuilder: (BuildContext context, ControlsDetails controls) {
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
                fontSize: 16,
              ),
            )),
            getRightButton(model, context),
          ]),
          //TODO 条件更换
          if (model.status >= 30 && _isFirst(model))
            Container(
              alignment: Alignment.centerLeft,
              // margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
              // decoration: BoxDecoration(
              //   color: ColorConstant.Text_5FC88F_10per,
              //   borderRadius: BorderRadius.all(
              //     Radius.circular(4),
              //   ),
              // ),
              child: Text(
                "采集器编号：" + order.serialNum,
                style: TextStyle(
                  color: ColorConstant.Text_5E6F88,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          if (model.status >= 50 && model.status < 80 && _isThird(model))
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
              decoration: BoxDecoration(
                color: ColorConstant.Text_5FC88F_10per,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Text(
                "实验室收到样本后会进行上机检测，基因报告约在15天完成。",
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
    print(steps.indexOf(model));
    print(_position);

    if (steps.indexOf(model) == 1 && _position == 2) {
      return true;
    }
    return steps.indexOf(model) == _position;
  }

  _isFirst(model) {
    return steps.indexOf(model) < 1;
  }

  _isThird(model) {
    return _position == 2;
  }

  getRightButton(model, context) {
    if (model.status <= 30 || (model.status >= 50 && model.status < 80)) {
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
              // await NavigatorUtil.orderStepNavigator(
              //     context, model.status, order);
              switch (model.status) {
                case 40:
                  // NavigatorUtil.push(
                  //     context,
                  //     SendBackAcquisitionPage(
                  //         ordId: order.id,
                  //         ordName: order.targetName,
                  //         ordNum: order.serialNum));
                  if ((steps.indexOf(model) == 1 && _position == 2)) {
                    NavigatorUtil.push(
                        context,
                        BaseWebView(
                          url: ApiConstant.getSFH5DetailUrl(order.order.reSfNo),
                          title: "物流跟踪",
                          isShare: false,
                        ));
                    break;
                  }
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SendBackAcquisitionPage(
                              ordId: order.id,
                              ordName: order.targetName,
                              ordNum: order.serialNum)));
                  if (result != null) {
                    getHttp();
                    if (_easyController != null) {
                      _easyController.resetLoadState();
                    }
                  }
                  break;
                // case 50:
                //   NavigatorUtil.push(
                //       context,
                //       BaseWebView(
                //         url: ApiConstant.getSFH5DetailUrl(order.order.reSfNo),
                //         title: "物流跟踪",
                //         isShare: false,
                //       ));
                //   break;
                case 60:
                  NavigatorUtil.push(
                      context,
                      BaseWebView(
                        url: ApiConstant.getSFH5DetailUrl(order.order.reSfNo),
                        title: "物流跟踪",
                        isShare: false,
                      ));
                  break;
                case 70:
                  NavigatorUtil.push(
                      context,
                      BaseWebView(
                        url: ApiConstant.getSFH5DetailUrl(order.order.reSfNo),
                        title: "物流跟踪",
                        isShare: false,
                      ));
                  break;
                case 80:
                  // bus.emit("ReportPageRefush", order.serialNum);
                  CommonUtils.toUrl(
                      context: context,
                      url: CommonUtils.URL_REPORT +
                          "?serialNum=" +
                          order.serialNum);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  break;
                default:
              }
              getHttp();
            }
          : null,
      child: Text(
          (steps.indexOf(model) == 1 && _position == 2)
              ? "物流跟踪"
              : ((_position == 3 && steps.indexOf(model) == 1)
                  ? "物流跟踪"
                  : model.title2),
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
