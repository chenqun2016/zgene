import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:fluwx/fluwx.dart';
import 'package:tobias/tobias.dart' as tobias;
import 'package:zgene/configure.dart'
    if (dart.library.html) 'package:zgene/configure_web.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/address_list_model.dart';
import 'package:zgene/models/archive_des_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/my/my_order_list.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

import '../my/my_address_list.dart';

class OrderingPage extends BaseWidget {
  Archive product;

  OrderingPage({Key key, this.product}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _OrderingPageState();
  }
}

class _OrderingPageState extends BaseWidgetState<OrderingPage> {
  var canPay = false;
  var isWeixinPay = true;
  var fapiao = 0;
  String _initProvince = '上海市', _initCity = '上海市', _initTown = '黄浦区';

  List _billDes = [
    "购买后那您如不需开发票，可在付款后60天内联系客服进行查询和申请。",
    "电子发票将在15个工作日内发送到您的电子邮箱，请注意查收。",
    "电子发票将在15个工作日内发送到您的电子邮箱，请注意查收。"
  ];
  List _billHint = [
    ["备注留言（选填）", null, null],
    ["请填写收票人电子邮箱", null, null],
    ["请填写收票人电子邮箱", "请填写单位名称", "请填写纳税人识别码"]
  ];

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _areaController = new TextEditingController();

  TextEditingController _messageController = new TextEditingController();
  TextEditingController _message2Controller = new TextEditingController();
  TextEditingController _message3Controller = new TextEditingController();

  bool _canClick = false;

  // GlobalKey _formKey = new GlobalKey<FormState>();
  // ScrollController _controller = new ScrollController();
  //
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  bool _getCanClick() {
    return _phoneController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _areaController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        (fapiao == 2
            ? (_messageController.text.isNotEmpty &&
                _message2Controller.text.isNotEmpty &&
                _message3Controller.text.isNotEmpty)
            : fapiao == 1
                ? _messageController.text.isNotEmpty
                : true);
  }

  void _checkCanClick() {
    var canClick = _getCanClick();
    if (_canClick != canClick) {
      setState(() {
        _canClick = canClick;
      });
    }
  }

  @override
  void pageWidgetInitState() {
    showBaseHead = false;
    pageWidgetTitle = "填写订单";
    showHead = true;
    isListPage = true;
    backImgPath = "assets/images/mine/img_bg_my.png";

    super.pageWidgetInitState();
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 90),
          child: SingleChildScrollView(
            controller: listeningController,
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding:
                  EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 30),
              children: [
                _tips,
                _prodectDetail,
                _addressDetail,
                _payDetail,
                _fapiaoDetail,
              ],
            ),
          ),
        ),
        _bottom,
      ],
    );
  }

  Widget get _fapiaoDetail {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      padding: EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        color: Colors.white70,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("发票",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConstant.TextMainBlack,
              )),
          Container(
            margin: EdgeInsets.only(left: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  minWidth: 72,
                  padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(
                        color: fapiao == 0
                            ? ColorConstant.TextMainColor
                            : ColorConstant.Divider),
                  ),
                  color: ColorConstant.WhiteColor,
                  onPressed: () {
                    if (fapiao == 0) {
                      return;
                    }
                    setState(() {
                      fapiao = 0;
                    });
                    _checkCanClick();
                  },
                  child: Text("不需要发票",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: fapiao == 0
                            ? ColorConstant.TextMainColor
                            : ColorConstant.TextMainBlack,
                      )),
                ),
                MaterialButton(
                  minWidth: 72,
                  padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(
                        color: fapiao == 1
                            ? ColorConstant.TextMainColor
                            : ColorConstant.Divider),
                  ),
                  color: ColorConstant.WhiteColor,
                  onPressed: () {
                    if (fapiao == 1) {
                      return;
                    }
                    setState(() {
                      fapiao = 1;
                    });
                    _checkCanClick();
                  },
                  child: Text("个人",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: fapiao == 1
                            ? ColorConstant.TextMainColor
                            : ColorConstant.TextMainBlack,
                      )),
                ),
                MaterialButton(
                  minWidth: 72,
                  padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(
                        color: fapiao == 2
                            ? ColorConstant.TextMainColor
                            : ColorConstant.Divider),
                  ),
                  color: ColorConstant.WhiteColor,
                  onPressed: () {
                    if (fapiao == 2) {
                      return;
                    }
                    setState(() {
                      fapiao = 2;
                    });
                    _checkCanClick();
                  },
                  child: Text("公司",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: fapiao == 2
                            ? ColorConstant.TextMainColor
                            : ColorConstant.TextMainBlack,
                      )),
                )
              ],
            ),
          ),
          _faPiao1(
              des: _billDes[fapiao],
              hint: _billHint[fapiao][0],
              hint2: _billHint[fapiao][1],
              hint3: _billHint[fapiao][2]),
        ],
      ),
    );
  }

  Widget _faPiao1(
      {@required String des,
      @required String hint,
      String hint2,
      String hint3}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 35, top: 8, bottom: 12),
          child: Text(
            des,
            style: TextStyle(
                color: ColorConstant.Text_5E6F88,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        TextField(
            controller: _messageController,
            onChanged: (str) {
              _checkCanClick();
            },
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
                fontSize: 15),
            decoration: InputDecoration(
              disabledBorder: _textLineBorder,
              focusedBorder: _textLineBorder,
              enabledBorder: _textLineBorder,
              border: _textLineBorder,
              contentPadding: EdgeInsets.fromLTRB(15, 12, 0, 12),
              isCollapsed: true,
              // suffixIcon: GestureDetector(
              //   onTap: () {},
              //   child: Icon(Icons.keyboard_arrow_down),
              // ),
              // suffixStyle: TextStyle(color: ColorConstant.TextMainColor),
              fillColor: ColorConstant.bg_EBEDEF,
              filled: true,
              hintText: hint,
              hintMaxLines: 1,
              hintStyle: TextStyle(
                  color: ColorConstant.Text_5E6F88,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
              icon: Container(
                width: 20,
                height: 20,
              ),
            )),
        if (null != hint2)
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: TextField(
                controller: _message2Controller,
                onChanged: (str) {
                  _checkCanClick();
                },
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.TextMainBlack,
                    fontSize: 15),
                decoration: InputDecoration(
                  disabledBorder: _textLineBorder,
                  focusedBorder: _textLineBorder,
                  enabledBorder: _textLineBorder,
                  border: _textLineBorder,
                  contentPadding: EdgeInsets.fromLTRB(15, 12, 0, 12),
                  isCollapsed: true,
                  // suffixIcon: GestureDetector(
                  //   onTap: () {},
                  //   child: Icon(Icons.keyboard_arrow_down),
                  // ),
                  // suffixStyle: TextStyle(color: ColorConstant.TextMainColor),
                  fillColor: ColorConstant.bg_EBEDEF,
                  filled: true,
                  hintText: hint2,
                  hintMaxLines: 1,
                  hintStyle: TextStyle(
                      color: ColorConstant.Text_5E6F88,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  icon: Container(
                    width: 20,
                    height: 20,
                  ),
                )),
          ),
        if (null != hint3)
          TextField(
              controller: _message3Controller,
              onChanged: (str) {
                _checkCanClick();
              },
              keyboardType: TextInputType.multiline,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.TextMainBlack,
                  fontSize: 15),
              decoration: InputDecoration(
                disabledBorder: _textLineBorder,
                focusedBorder: _textLineBorder,
                enabledBorder: _textLineBorder,
                border: _textLineBorder,
                contentPadding: EdgeInsets.fromLTRB(15, 12, 0, 12),
                isCollapsed: true,
                // suffixIcon: GestureDetector(
                //   onTap: () {},
                //   child: Icon(Icons.keyboard_arrow_down),
                // ),
                // suffixStyle: TextStyle(color: ColorConstant.TextMainColor),
                fillColor: ColorConstant.bg_EBEDEF,
                filled: true,
                hintText: hint3,
                hintMaxLines: 1,
                hintStyle: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                icon: Container(
                  width: 20,
                  height: 20,
                ),
              ))
      ],
    );
  }

  Widget get _payDetail {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      padding: EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        color: Colors.white70,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("支付方式",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConstant.TextMainBlack,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isWeixinPay = true;
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 14, right: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isWeixinPay
                              ? ColorConstant.TextMainColor
                              : ColorConstant.bg_D1D8E2,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/buy/icon_weixinpay.png",
                            height: 40,
                            width: 40,
                            fit: BoxFit.fill,
                          ),
                          Divider(
                            height: 6,
                            color: Colors.transparent,
                          ),
                          Text("微信支付",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.TextMainBlack,
                              )),
                        ],
                      ),
                    ),
                    if (isWeixinPay)
                      Positioned(
                        top: 9,
                        right: 0,
                        child: Image.asset(
                          "assets/images/buy/img_ok.png",
                          height: 20,
                          width: 20,
                        ),
                      )
                  ],
                ),
              ),
              PlatformUtils.isWeb &&
                      CommonConstant.isInWechatWeb // 如果是微信内，只支持微信支付
                  ? Container(
                      width: 100,
                      height: 100,
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          isWeixinPay = false;
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(top: 14, right: 5, left: 47),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isWeixinPay
                                    ? ColorConstant.bg_D1D8E2
                                    : ColorConstant.TextMainColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/buy/icon_zhifubaopay.png",
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.fill,
                                ),
                                Divider(
                                  height: 6,
                                  color: Colors.transparent,
                                ),
                                Text("支付宝支付",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: ColorConstant.TextMainBlack,
                                    )),
                              ],
                            ),
                          ),
                          if (!isWeixinPay)
                            Positioned(
                              top: 9,
                              right: 0,
                              child: Image.asset(
                                "assets/images/buy/img_ok.png",
                                height: 20,
                                width: 20,
                              ),
                            )
                        ],
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }

  Widget get _addressDetail {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      padding: EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        color: Colors.white70,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text("收货信息",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.TextMainBlack,
                      ))),
              GestureDetector(
                onTap: () async {
                  try {
                    AddressListModel address = await NavigatorUtil.push(
                        context,
                        MyAddressListPage(
                          isSelectFrom: true,
                        ));
                    if (null != address) {
                      _nameController.text = address.rcvName;
                      _phoneController.text = address.rcvPhone;
                      _cityController.text =
                          address.province + address.city + address.county;
                      _areaController.text = address.address;
                      _checkCanClick();
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Image.asset(
                  "assets/images/buy/icon_tianjia.png",
                  height: 26,
                  width: 26,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.transparent,
            height: 10,
          ),
          TextField(
              controller: _nameController,
              onTap: onTextTab,
              // validator: (v) {
              //   return v.trim().length > 0 ? null : "";
              // },
              onChanged: (str) {
                _checkCanClick();
              },
              inputFormatters: UiUitls.getInputFormatters(max: 20),
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.TextMainBlack,
                  fontSize: 15),
              // inputFormatters: [LengthLimitingTextInputFormatter(20)],
              decoration: InputDecoration(
                disabledBorder: _textLineBorder,
                focusedBorder: _textLineBorder,
                enabledBorder: _textLineBorder,
                errorBorder: _textLineBorder,
                focusedErrorBorder: _textLineBorder,
                border: _textLineBorder,
                contentPadding: EdgeInsets.fromLTRB(15, 12, 0, 12),
                isCollapsed: true,
                fillColor: ColorConstant.bg_EBEDEF,
                filled: true,
                hintText: "请填写收货人姓名",
                hintMaxLines: 1,
                hintStyle: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                icon: Image.asset(
                  "assets/images/buy/icon_user.png",
                  height: 20,
                  width: 20,
                ),
              )),
          Divider(
            color: Colors.transparent,
            height: 10,
          ),
          TextField(
              controller: _phoneController,
              onTap: onTextTab,
              // validator: (v) {
              //   return v.trim().length > 0 ? null : "";
              // },
              onChanged: (str) {
                _checkCanClick();
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              maxLines: 1,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.TextMainBlack,
                  fontSize: 15),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(11)
              ],
              decoration: InputDecoration(
                disabledBorder: _textLineBorder,
                focusedBorder: _textLineBorder,
                enabledBorder: _textLineBorder,
                errorBorder: _textLineBorderError,
                focusedErrorBorder: _textLineBorderError,
                border: _textLineBorder,
                contentPadding: EdgeInsets.fromLTRB(15, 12, 0, 12),
                isCollapsed: true,
                fillColor: ColorConstant.bg_EBEDEF,
                filled: true,
                hintText: "请填写收货人手机号码",
                hintMaxLines: 1,
                hintStyle: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                icon: Image.asset(
                  "assets/images/buy/iocn_dizhi.png",
                  height: 20,
                  width: 20,
                ),
              )),
          Divider(
            color: Colors.transparent,
            height: 10,
          ),
          TextField(
              controller: _cityController,
              // validator: (v) {
              //   return v.trim().length > 0 ? null : "";
              // },
              onChanged: (str) {
                _checkCanClick();
              },
              onTap: () {
                Pickers.showAddressPicker(
                  context,
                  addAllItem: false,
                  initProvince: _initProvince,
                  initCity: _initCity,
                  initTown: _initTown,
                  onConfirm: (p, c, t) {
                    setState(() {
                      _initProvince = p;
                      _initCity = c;
                      _initTown = t;
                    });
                    _cityController.text =
                        _initProvince + _initCity + _initTown;
                  },
                );
                onTextTab();
              },
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              readOnly: true,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.TextMainBlack,
                  fontSize: 15),
              decoration: InputDecoration(
                disabledBorder: _textLineBorder,
                focusedBorder: _textLineBorder,
                enabledBorder: _textLineBorder,
                errorBorder: _textLineBorder,
                focusedErrorBorder: _textLineBorder,
                border: _textLineBorder,
                contentPadding: EdgeInsets.fromLTRB(15, 12, 0, 12),
                isCollapsed: true,
                suffixIcon: GestureDetector(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
                fillColor: ColorConstant.bg_EBEDEF,
                filled: true,
                hintText: "请选择所在地区",
                hintMaxLines: 1,
                hintStyle: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                icon: Image.asset(
                  "assets/images/buy/iocn_phone.png",
                  height: 20,
                  width: 20,
                ),
              )),
          Divider(
            color: Colors.transparent,
            height: 10,
          ),
          TextField(
              controller: _areaController,
              // validator: (v) {
              //   return v.trim().length > 0 ? null : "";
              // },
              onTap: onTextTab,
              onChanged: (str) {
                _checkCanClick();
              },
              inputFormatters: UiUitls.getInputFormatters(),
              keyboardType: TextInputType.multiline,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.TextMainBlack,
                  fontSize: 15),
              // inputFormatters: [LengthLimitingTextInputFormatter(100)],
              decoration: InputDecoration(
                disabledBorder: _textLineBorder,
                focusedBorder: _textLineBorder,
                enabledBorder: _textLineBorder,
                errorBorder: _textLineBorder,
                focusedErrorBorder: _textLineBorder,
                border: _textLineBorder,
                contentPadding: EdgeInsets.fromLTRB(15, 12, 0, 12),
                isCollapsed: true,
                // suffixIcon: GestureDetector(
                //   onTap: () {},
                //   child: Icon(Icons.keyboard_arrow_down),
                // ),
                // suffixStyle: TextStyle(color: ColorConstant.TextMainColor),
                fillColor: ColorConstant.bg_EBEDEF,
                filled: true,
                hintText: "请填写详细地址",
                hintMaxLines: 1,
                hintStyle: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                icon: Container(
                  width: 20,
                  height: 20,
                ),
              )),
        ],
      ),
    );
  }

  void onTextTab() {
    // if (_controller.offset < 300) {
    //   _controller.animateTo(300,
    //       duration: Duration(milliseconds: 300), curve: Curves.linear);
    // }
  }

  OutlineInputBorder get _textLineBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: Colors.transparent,
      ),
    );
  }

  OutlineInputBorder get _textLineBorderError {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: Colors.red,
      ),
    );
  }

  Widget get _prodectDetail {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 67),
          width: double.infinity,
          padding: EdgeInsets.only(top: 100, bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            color: Colors.white70,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Text(widget.product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.TextMainBlack,
                  )),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("单价：¥${CommonUtils.formatMoney(widget.product.coin)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.TextMainColor,
                        )),
                    Text("X1",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.Text_5E6F88,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40),
          child: Image.asset(
            "assets/images/buy/img_zhutu.png",
            height: 110,
            width: 110,
          ),
        ),
      ],
    );
  }

  Widget get _tips {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(44, 6, 0, 6),
          decoration: BoxDecoration(
            color: ColorConstant.TextMainColor_10per,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Text("温馨提示：一个采集器仅供一人使用哦~",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorConstant.TextMainColor,
              )),
        ),
        Image.asset(
          "assets/images/buy/icon_tixing.png",
          height: 38,
          width: 38,
        )
      ],
    );
  }

  Widget get _bottom {
    return Positioned(
        left: 0,
        bottom: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 15),
          color: Colors.white,
          height: 90,
          child: Row(
            children: [
              Text("应付：",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.Text_8E9AB,
                  )),
              Text("¥",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextMainColor,
                  )),
              Expanded(
                  flex: 1,
                  child: Text("${CommonUtils.formatMoney(widget.product.coin)}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.TextMainColor,
                      ))),
              MaterialButton(
                minWidth: 158,
                height: 55,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                color: ColorConstant.TextMainColor,
                disabledColor: ColorConstant.Text_B2BAC6,
                onPressed: _canClick
                    ? () {
                        doPay();
                      }
                    : null,
                child: Text("立即支付",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ));
  }

  Future<void> doPay() async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }

    Map<String, dynamic> map = new HashMap();
    map['pid'] = widget.product.id;
    map['price'] = widget.product.coin;
    map['nums'] = 1;

    map['amounts'] = widget.product.coin;
    map['rcv_name'] = _nameController.text.toString();
    map['rcv_phone'] = _phoneController.text.toString();
    map['province'] = _initProvince;
    map['city'] = _initCity;
    map['county'] = _initTown;
    map['address'] = _areaController.text.toString();
    map['pay_type'] = isWeixinPay ? 2 : 1;

    Map<String, dynamic> mapBill = new HashMap();
    mapBill['bill_type'] = (fapiao + 1).toString();
    if (fapiao == 0) {
      mapBill['remark'] = _messageController.text.toString();
    }
    if (fapiao == 1) {
      mapBill['email'] = _messageController.text.toString();
    }
    if (fapiao == 2) {
      mapBill['email'] = _messageController.text.toString();
      mapBill['company'] = _message2Controller.text.toString();
      mapBill['numbers'] = _message3Controller.text.toString();
    }
    map['bill'] = mapBill;
    if (PlatformUtils.isWeb && CommonConstant.isInWechatWeb) {
      map['open_id'] = CommonConstant.wechatWebOpenID;
    }

    HttpUtils.requestHttp(
      ApiConstant.ordering,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (result) async {
        EasyLoading.dismiss();

        log("ordering result==${result}");
        if (isWeixinPay) {
          if (PlatformUtils.isWeb && CommonConstant.isInWechatWeb) {
            // 微信服务号内支付
            var parms = json.encode(result);
            webWeixinPay(parms);
          } else {
            // APP内支付
            payWithWeChat(
              appId: result['appid'],
              partnerId: result['partnerid'],
              prepayId: result['prepayid'],
              packageValue: result['package'],
              nonceStr: result['noncestr'],
              timeStamp: result['timestamp'],
              sign: result['sign'],
            );

            // 监听支付结果
            weChatResponseEventHandler.listen((event) async {
              print(event.errCode);
              // 支付成功
              if (event.errCode == 0) {
                _toOrder();
              }
              // 关闭弹窗
            });
          }
        } else {
          var aliPay = await tobias.aliPay(result['pay_param']);

          log("aliPay result==${aliPay}");

          // 支付成功
          if ('9000' == aliPay['resultStatus']) {
            _toOrder();
          }
        }
      },
      onError: (code, error) {
        UiUitls.showToast(error);
      },
    );
  }

  void _toOrder() {
    Future.delayed(Duration(seconds: 1), () {
      NavigatorUtil.pushAndRemoveUntil(context, MyOrderListPage());
    });
  }
}
