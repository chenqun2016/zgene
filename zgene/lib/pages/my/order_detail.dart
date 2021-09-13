import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/order_list_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/date_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/time_utils.dart';

import 'my_contant_us.dart';

///订单详情
class OrderDetailPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _OrderDetailState();
  }
}

class _OrderDetailState extends BaseWidgetState<OrderDetailPage> {
  String appAsalesRules = SpUtils().getStorageDefault(
      SpConstant.appAsalesRules, CommonConstant.defaultAppAsalesRules);

  @override
  void initState() {
    super.initState();
    pageWidgetTitle = "订单详情";
    backImgPath = "assets/images/mine/img_bg_my.png";
  }

  OrderListmodel _model;
  var orderId = "";

  @override
  Widget viewPageBody(BuildContext context) {
    //获取路由传的参数
    orderId = ModalRoute.of(context).settings.arguments;
    if (null != _model)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getTopInfo(),
          _getBottomInfo(),
          _bottom(),
        ],
      );
    getHttp();
    return Container();
  }

  getHttp() {
    Map<String, dynamic> map = new HashMap();
    map["order_id"] = orderId;
    HttpUtils.requestHttp(
      ApiConstant.orderDetail,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (data) {
        print(data);
        OrderListmodel orderModel = OrderListmodel.fromJson(data);
        _model = orderModel;
        setState(() {});
      },
      onError: (code, error) {},
    );
  }

  ///顶部信息
  Widget _getTopInfo() {
    var sfno;
    if (_model.status == 20) {
      sfno = _model.sfNo;
    } else if (_model.status == 50) {
      sfno = _model.reSfNo;
    }
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Stack(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.fromLTRB(16, 25, 16, 0),
          decoration: BoxDecoration(
            color: Color(0xB3FFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              if (null != _model.prodInfo)
                Container(
                  margin: EdgeInsets.only(top: 90, bottom: 10),
                  child: Text(_model.prodInfo.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF112950),
                        fontWeight: FontWeight.w500,
                      )),
                ),
              if (null != sfno)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("顺丰快递  ${sfno}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF5E6F88),
                        )),
                    GestureDetector(
                      onTap: () {
                        _onTapEvent(1);
                      },
                      child: Text("跟踪物流",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF007AF7),
                          )),
                    ),
                  ],
                )
            ],
          ),
        ),
        if (null != _model.prodInfo)
          Positioned(
            child: Center(
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/home/img_default2.png',
                    image: CommonUtils.splicingUrl(_model.prodInfo.images),
                    width: 116,
                    height: 116,
                    fadeInDuration: TimeUtils.fadeInDuration(),
                    fadeOutDuration: TimeUtils.fadeOutDuration(),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/home/img_default2.png',
                        width: 116,
                        height: 116,
                        fit: BoxFit.fill,
                      );
                    }),
              ),
            ),
          ),
      ]),
    );
  }

  ///底部信息
  Widget _getBottomInfo() {
    var textStyle = TextStyle(
      fontSize: 15,
      color: Color(0xFF191C32),
      fontWeight: FontWeight.w700,
    );
    var textStyleRight = TextStyle(
      fontSize: 14,
      color: Color(0xFF5E6F88),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(16, 7, 16, 15),
      margin: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xB3FFFFFF),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(left: 100, top: 16),
                  child: Text(
                    _model.id.toString(),
                    style: textStyleRight,
                    textAlign: TextAlign.right,
                  ),
                ),
                Positioned(
                  child: Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        "订单号",
                        style: textStyle,
                      )),
                ),
              ],
            ),
          ),
          if (null != _model.prodInfo)
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(left: 100, top: 16),
                    child: Text(
                      _model.prodInfo.name,
                      style: textStyleRight,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Positioned(
                    child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          "商品",
                          style: textStyle,
                        )),
                  ),
                ],
              ),
            ),
          if (null != _model.revAddress)
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(left: 100, top: 16),
                    child: Text(
                      _model.revAddress.province +
                          _model.revAddress.city +
                          _model.revAddress.county +
                          _model.revAddress.address +
                          "," +
                          _model.revAddress.rcvName +
                          "," +
                          _model.revAddress.rcvPhone,
                      style: textStyleRight,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Positioned(
                    child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          "收件信息",
                          style: textStyle,
                        )),
                  ),
                ],
              ),
            ),
          GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(left: 100, top: 16),
                  child: Text(
                    CusDateUtils.getFormatDataS(
                        timeSamp: _model.createdAt,
                        format: CusDateUtils.PARAM_TIME_FORMAT_H_M),
                    style: textStyleRight,
                    textAlign: TextAlign.right,
                  ),
                ),
                Positioned(
                  child: Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        "日期",
                        style: textStyle,
                      )),
                ),
              ],
            ),
          ),
          if (null != _model.billInfo)
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(left: 100, top: 16),
                    child: Text(
                      _model.billInfo.company,
                      style: textStyleRight,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Positioned(
                    child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          "发票信息",
                          style: textStyle,
                        )),
                  ),
                ],
              ),
            ),
          if (null != _model.billInfo)
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(left: 100, top: 16),
                    child: Text(
                      _model.billInfo.numbers,
                      style: textStyleRight,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Positioned(
                    child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          "纳税人识别号",
                          style: textStyle,
                        )),
                  ),
                ],
              ),
            ),
          if (null != _model.billInfo)
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(left: 100, top: 16),
                    child: Text(
                      _model.billInfo.email,
                      style: textStyleRight,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Positioned(
                    child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          "收票邮箱",
                          style: textStyle,
                        )),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  ///底部
  Widget _bottom() {
    var textStyle = TextStyle(
      fontSize: 14,
      color: Color(0xFF007AF7),
    );
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _onTapEvent(2);
            },
            child: Text(
              "联系客服",
              style: textStyle,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              "|",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5E6F88),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _onTapEvent(3);
            },
            child: Text(
              "售后规则",
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }

  ///点击事件
  _onTapEvent(index) {
    switch (index) {
      case 1: //跟踪物流
        NavigatorUtil.orderStepNavigator(context, _model.status, _model);
        break;
      case 2: //联系客服
        NavigatorUtil.push(context, contantUsPage());
        break;
      case 3: //售后规则
        _showRule();
        break;
    }
  }

  ///规则的展示
  _showRule() {
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: ColorConstant.AppleBlack99Color,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ColorConstant.WhiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 21, left: 16),
                        height: 25,
                        width: double.infinity,
                        child: Text(
                          "售后规则：",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.TextSecondColor,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 11,
                        top: 18,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/mine/icon_quxiao.png"),
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Scrollbar(
                    // 显示进度条
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Expanded(child: Text(appAsalesRules)),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
