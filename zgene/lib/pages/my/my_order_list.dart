import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/refresh_config_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

///我的订单列表
class MyOrderListPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _MyOrderListState();
  }
}

class _MyOrderListState extends BaseWidgetState<MyOrderListPage> {
  EasyRefreshController _controller;
  List list = [];
  List tempList = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    pageWidgetTitle = "我的订单";
    backImgPath = "assets/images/mine/img_bg_my.png";
    customRightBtnText = "采集引导";
    isListPage = true;
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return EasyRefresh(
      // 是否开启控制结束加载
      enableControlFinishLoad: false,
      firstRefresh: true,
      // 控制器
      controller: _controller,
      header: RefreshConfigUtils.classicalHeader(),
      // 自定义顶部上啦加载
      footer: RefreshConfigUtils.classicalFooter(),
      child: _listView,
      //下拉刷新事件回调
      onRefresh: () async {
        // page = 1;
        // // 获取数据
        // getHttp();
        // await Future.delayed(Duration(seconds: 1), () {
        // 重置刷新状态 【没错，这里用的是resetLoadState】
        if (_controller != null) {
          _controller.resetLoadState();
        }
        // });
      },
      // 上拉加载事件回调
      onLoad: () async {
        // await Future.delayed(Duration(seconds: 1), () {
        //   // 获取数据
        //   getHttp();
        // 结束加载
        _controller.finishLoad();
        // _controller.finishLoad(noMore:true);
        // });
      },
    );
  }

  ///列表
  Widget get _listView {
    return Container(
      margin: EdgeInsets.all(0),
      width: double.infinity,
      child: ListView.builder(
        itemCount: 6,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return getItem();
        },
      ),
    );
  }

  Widget getItem() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 17, 0, 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Text(
                  "订单编号：16299628c418d7ae",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF8E9AAB),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
                  decoration: BoxDecoration(
                    color: Color(0x16007AF7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(17),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Text(
                    "待发货",
                    style: TextStyle(
                        fontSize: 14, color: ColorConstant.MainBlueColor),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/banner.png',
                          image: "",
                          width: 70,
                          height: 70,
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          fadeInDuration: TimeUtils.fadeInDuration(),
                          fadeOutDuration: TimeUtils.fadeOutDuration(),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/banner.png',
                              width: 70,
                              height: 70,
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                            );
                          }),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 136,
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Z基因-精装版-家庭套装",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF112950),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Text(
                                "¥499",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF112950),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "X1",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF8E9AAB),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),

                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 14, 0, 17),
                  child: Divider(
                    height: 1.0,
                    indent: 0,
                    endIndent: 0,
                    color: ColorConstant.LineMainColor,
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      child: Text(
                        "交易时间：2021-08-26 11:20",
                        style: TextStyle(
                            fontSize: 13, color: ColorConstant.Text_8E9AB),
                        textAlign: TextAlign.left,
                      ),
                      width: double.infinity,
                    ),

                    Positioned(
                        right: 0,
                        child: Text(
                          "¥481",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF112950),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  rightBtnTap(BuildContext context) {
    UiUitls.showToast("dddddd");
  }
}
