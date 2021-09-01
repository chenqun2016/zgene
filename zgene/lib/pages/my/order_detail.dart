import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/ui_uitls.dart';

///订单详情
class OrderDetailPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _OrderDetailState();
  }
}

class _OrderDetailState extends BaseWidgetState<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    pageWidgetTitle = "订单详情";
    backImgPath = "assets/images/mine/img_bg_my.png";
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getTopInfo(),
        _getBottomInfo(),
        _bottom(),
      ],
    );
  }

  ///顶部信息
  Widget _getTopInfo() {
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
              Container(
                margin: EdgeInsets.only(top: 90, bottom: 10),
                child: Text("Z基因-精装版-家庭套装",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF112950),
                      fontWeight: FontWeight.w500,
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("顺丰快递 SF78898587888 ",
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
        Positioned(
          child: Center(
            child: Image(
              image: AssetImage("assets/images/mine/img_zhutu.png"),
              height: 116,
              width: 116,
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
                    "78898587888",
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
                    "ZGene 检测标准版 3.0 X1",
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
                    "上海市 山西南路187号(山西南路天津路),张三,1862888913路187号(山西南路天津路),张三,1862888913",
                    style: textStyleRight,
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
                    "2021-08-10  17:28:36",
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
                    "上海XX互联网科技有限公司",
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
                    "98545MGHNH5555845",
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
                    "suiug@126.com",
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
        UiUitls.showToast("跟踪物流");
        break;
      case 2: //联系客服
        UiUitls.showToast("联系客服");
        break;
      case 3: //售后规则
        _showRule();
        break;
    }
  }

  ///规则的展示
  _showRule() {
    showModalBottomSheet(
      barrierColor: ColorConstant.AppleBlack99Color,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          height: 419,
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorConstant.WhiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          image: AssetImage("assets/images/mine/icon_quxiao.png"),
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
                  child: Expanded(child: Text("发送到发撒旦法撒打发斯蒂芬仿阿萨德发送到会计法"*10)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
