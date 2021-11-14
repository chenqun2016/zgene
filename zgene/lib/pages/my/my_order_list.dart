import 'package:base/widget/base_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/order_list_model.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/date_utils.dart';
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
  List<dynamic> list = [];
  int page = 1;
  int errorCode = 0; //0.正常 1.暂无数据 2.错误 3.没有网络

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    pageWidgetTitle = "我的订单";
    backImgPath = "assets/images/mine/img_bg_my.png";
    customRightBtnText = "采集引导";
    isListPage = true;
    nullImgText = "暂无订单";
  }

  Future<void> getDatas() async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }
    //  ;
    HttpUtils.requestHttp(
      ApiConstant.orderList,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        EasyLoading.dismiss();
        setState(() {
          list = result;
        });
        if (list.length > 0) {
          nullImgIsHidden = true;
        } else {
          nullImgIsHidden = false;
        }
      },
      onError: (code, error) {
        EasyLoading.showError(error);
      },
    );
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return errorCode != 0
        ? UiUitls.getErrorPage(
            context: context,
            type: errorCode,
            onClick: () {
              // if (lastTime == null) {
              //   lastTime = DateTime.now();
              //   page = 1;
              //   getHttp();
              // } else {
              //   //可以点击
              //   if (TimeUtils.intervalClick(lastTime, 2)) {
              //     lastTime = DateTime.now();
              //     page = 1;
              //     getHttp();
              //   }
              // }
            })
        : Container(
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Color(0xB3FFFFFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: EasyRefresh(
              // 是否开启控制结束加载
              enableControlFinishLoad: false,
              firstRefresh: true,
              // 控制器
              controller: _controller,
              header: BallPulseHeader(),
              // footer: BallPulseFooter(),
              child: _listView,
              //下拉刷新事件回调
              onRefresh: () async {
                // page = 1;
                // // 获取数据
                await getDatas();
                // 重置刷新状态 【没错，这里用的是resetLoadState】
                if (_controller != null) {
                  _controller.resetLoadState();
                }
                // });
              },
              // 上拉加载事件回调
              // onLoad: () async {
              //   // await Future.delayed(Duration(seconds: 1), () {
              //   //   // 获取数据
              //   //   getHttp();
              //   // 结束加载
              //   _controller.finishLoad();
              //   // _controller.finishLoad(noMore:true);
              //   // });
              // },
            ),
          );
  }

  ///列表
  Widget get _listView {
    return Container(
      margin: EdgeInsets.all(0),
      width: double.infinity,
      child: ListView.builder(
        controller: listeningController,
        itemCount: list.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 60),
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return getItem(list[index]);
        },
      ),
    );
  }

  Widget getItem(model) {
    OrderListmodel bean = OrderListmodel.fromJson(model);
    return GestureDetector(
      onTap: () {
        _onTapEvent(bean);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
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
                    "订单编号：${bean.id}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
                      CommonUtils.getOrderType(bean.status),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.MainBlueColor),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (null != bean.prodInfo)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: new CachedNetworkImage(
                            width: 82,
                            // 设置根据宽度计算高度
                            height: 82,
                            // 图片地址
                            imageUrl:
                                CommonUtils.splicingUrl(bean.prodInfo.images),
                            // 填充方式为cover
                            fit: BoxFit.cover,

                            errorWidget: (context, url, error) => new Container(
                              child: new Image.asset(
                                'assets/images/banner.png',
                                height: 82,
                                width: 82,
                              ),
                            ),
                          ),
                          // FadeInImage.assetNetwork(
                          //     placeholder: 'assets/images/banner.png',
                          //     image:
                          //         CommonUtils.splicingUrl(bean.prodInfo.images),
                          //     width: 70,
                          //     height: 70,
                          //     alignment: Alignment.center,
                          //     fit: BoxFit.fill,
                          //     fadeInDuration: TimeUtils.fadeInDuration(),
                          //     fadeOutDuration: TimeUtils.fadeOutDuration(),
                          //     imageErrorBuilder: (context, error, stackTrace) {
                          //       return Image.asset(
                          //         'assets/images/banner.png',
                          //         width: 70,
                          //         height: 70,
                          //         alignment: Alignment.center,
                          //         fit: BoxFit.fill,
                          //       );
                          //     }),
                        ),
                      if (null != bean.prodInfo)
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                bean.prodInfo.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF112950),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "X${bean.nums}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF8E9AAB),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  )),
                                  Text(
                                    "¥${CommonUtils.formatMoney(bean.price)}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF112950),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    ],
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
                          "交易时间：${CusDateUtils.getFormatDataS(timeSamp: bean.createdAt, format: CusDateUtils.PARAM_TIME_FORMAT_H_M)}",
                          style: TextStyle(
                              fontSize: 13, color: ColorConstant.Text_8E9AB),
                          textAlign: TextAlign.left,
                        ),
                        width: double.infinity,
                      ),
                      Positioned(
                          right: 0,
                          child: Row(children: [
                            Text(
                              "共 ${bean.nums} 件 实付",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF8E9AAB),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                "¥${CommonUtils.formatMoney(bean.price)}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF112950),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ])),
                    ],
                  ),
                  if (bean.status == 60 || bean.status == 70)
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 15),
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
                  // if (bean.status >= 20 && bean.status <= 70)
                  //   Container(
                  //     alignment: Alignment.topRight,
                  //     height: 32,
                  //     margin: EdgeInsets.only(top: 20),
                  //     child: RaisedButton(
                  //       color: ColorConstant.TextMainColor,
                  //       child: Text(
                  //         CommonUtils.getOrderStepType(bean.status),
                  //         style: TextStyle(
                  //           color: ColorConstant.WhiteColor,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(16)),
                  //       onPressed: () async {
                  //         await NavigatorUtil.orderStepNavigator(
                  //             context, bean.status, bean);
                  //
                  //         ///刷新状态
                  //         getDatas();
                  //       },
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  rightBtnTap(BuildContext context) {
    CommonUtils.toCollectionGuide(context);
  }

  ///点击事件
  _onTapEvent(OrderListmodel bean) async {
    await Navigator.of(context).pushNamed(CommonConstant.ROUT_order_step_detail,
        arguments: bean.id.toString());

    ///刷新状态
    getDatas();
  }
}
