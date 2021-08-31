import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/ui_uitls.dart';

class OrderingPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return _OrderingPageState();
  }
}

class _OrderingPageState extends BaseWidgetState<OrderingPage> {
  var canPay = false;
  var isWeixinPay = true;
  var fapiao = 0;

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
        ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 120),
          children: [
            _tips,
            _prodectDetail,
            _addressDetail,
            _payDetail,
            _fapiaoDetail,
          ],
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
                    setState(() {
                      fapiao = 0;
                    });
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
                    setState(() {
                      fapiao = 1;
                    });
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
                    setState(() {
                      fapiao = 2;
                    });
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
          Container(
            margin: EdgeInsets.only(left: 35, top: 8, bottom: 12),
            child: Text(
              "购买后那您如需不开发票，可在付款后60天内联系客服进行查询和申请",
              style: TextStyle(
                  color: ColorConstant.Text_5E6F88,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextField(
              onChanged: (str) {},
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
                hintText: "备注留言（选填）",
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
      ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isWeixinPay = true;
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(top: 14, left: 35),
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
                        fit: BoxFit.cover,
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
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isWeixinPay = false;
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 14, right: 35),
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
                        fit: BoxFit.cover,
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
              Image.asset(
                "assets/images/buy/icon_tianjia.png",
                height: 26,
                width: 26,
              ),
            ],
          ),
          Divider(
            color: Colors.transparent,
            height: 10,
          ),
          TextField(
              onChanged: (str) {},
              keyboardType: TextInputType.multiline,
              maxLines: 1,
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
              onChanged: (str) {},
              keyboardType: TextInputType.multiline,
              maxLines: 1,
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
              onTap: () {
                UiUitls.showToast("点击");
              },
              onChanged: (str) {},
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
                border: _textLineBorder,
                contentPadding: EdgeInsets.fromLTRB(15, 12, 0, 12),
                isCollapsed: true,
                suffixIcon: GestureDetector(
                  onTap: () {},
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
              onChanged: (str) {},
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

  OutlineInputBorder get _textLineBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: Colors.transparent,
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
              Text("Z基因-精装版-家庭套装",
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
                    Text("单价：¥799.00",
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
                  child: Text("799.0",
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
                onPressed: canPay
                    ? () {
                        NavigatorUtil.push(context, OrderingPage());
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
}
