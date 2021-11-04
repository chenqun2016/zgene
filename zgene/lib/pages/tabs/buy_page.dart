import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/statistics_constant.dart';
import 'package:zgene/event/event_bus.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/util/umeng_utils.dart';

///首页购买页面
class BuyPage extends BaseWidget {
  @override
  _BuyPageState getState() => _BuyPageState();
}

class _BuyPageState extends BaseWidgetState<BuyPage> {
  double appBarAlpha = 0;
  EasyRefreshController _easyController;
  List _products;

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    UmengUtils.onEvent(StatisticsConstant.TAB2_BUY,
        {StatisticsConstant.KEY_UMENG_L2: StatisticsConstant.TAB2_BUY_IMP});
    showBaseHead = false;
    showHead = false;
    isListPage = true;
    setWantKeepAlive = true;
    backImgPath = "assets/images/mine/img_bg_my.png";
    _easyController = EasyRefreshController();
    HomeGetHttp();
    bus.on("listMustRefresh", (arg) {
      HomeGetHttp();
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    bus.off("listMustRefresh");
    super.dispose();
  }

  Future<void> HomeGetHttp() async {
    // bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    // if (!isNetWorkAvailable) {
    //   return;
    // }

    Map<String, dynamic> map = new HashMap();
    map['chid'] = 5;
    HttpUtils.requestHttp(
      ApiConstant.contentList,
      parameters: map,
      isNeedCache: true,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        EasyLoading.dismiss();
        ContentModel contentModel = ContentModel.fromJson(result);
        print(result);
        if (null != contentModel &&
            null != contentModel.archives &&
            contentModel.archives.length > 0 &&
            mounted) {
          setState(() {
            _products = contentModel.archives;
          });
        }
      },
      onError: (code, error) {
        EasyLoading.showError(error);
      },
    );
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          _title,
          Expanded(
            //     child: EasyRefresh(
            //   // 是否开启控制结束加载
            //   enableControlFinishLoad: false,
            //   firstRefresh: true,
            //   // 控制器
            //   controller: _easyController,
            //   header: BallPulseHeader(),
            child: _listview,
            //   //下拉刷新事件回调
            //   onRefresh: () async {
            //     // page = 1;
            //     // // 获取数据
            //     HomeGetHttp();
            //     // await Future.delayed(Duration(seconds: 1), () {
            //     // 重置刷新状态 【没错，这里用的是resetLoadState】
            //     if (_easyController != null) {
            //       _easyController.resetLoadState();
            //     }
            //     // });
            //   },
            // )
          )
        ],
      ),
    );
  }

  Widget get _listview {
    return _products == null
        ? Text("")
        : ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 0, bottom: 90),
            children: _products?.map((e) => getItem(e))?.toList(),
          );
  }

  Widget getItem(Archives bean) {
    var isInActivity = false;
    if (bean.limitTime != null) {
      var endtime = bean.limitTime.end;
      var starttime = bean.limitTime.start;

      if (starttime <= DateTime.now().millisecondsSinceEpoch / 1000 &&
          endtime >= DateTime.now().millisecondsSinceEpoch / 1000) {
        try {
          isInActivity = true;
        } catch (e) {
          isInActivity = false;
        }
      }
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(CommonConstant.ROUT_buy_detail,
            arguments: bean.id.toString());
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 195,
        margin: EdgeInsets.fromLTRB(16, 17, 16, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 16,
              child: Hero(
                tag: bean.id.toString(),
                child: CachedNetworkImage(
                  width: 104,
                  // 设置根据宽度计算高度
                  height: 104,
                  // 图片地址
                  imageUrl: CommonUtils.splicingUrl(bean.imageUrl),
                  // 填充方式为cover
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 136,
              right: 0,
              top: 20,
              child: Text(
                bean.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.TextMainBlack,
                ),
              ),
            ),
            Positioned(
              left: 136,
              top: 90,
              right: 106,
              child: Row(
                children: [
                  Text(
                    isInActivity
                        ? "¥${CommonUtils.formatMoney(bean.limitCoin)}"
                        : "¥${CommonUtils.formatMoney(bean.coin)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.Text_FC4C4E,
                    ),
                  ),
                  Offstage(
                    offstage: !isInActivity,
                    child: Container(
                      margin: EdgeInsets.only(left: 6),
                      // padding: EdgeInsets.only(left: 6),
                      child: Text(
                        "¥${CommonUtils.formatMoney(bean.coin)}",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                          color: ColorConstant.Text_8E9AB,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container())
                ],
              ),
            ),
            Positioned(
                top: 85,
                right: 16,
                child: Container(
                  height: 32,
                  width: 78,
                  decoration: BoxDecoration(
                    color: ColorConstant.MainBlueColor,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "立即购买",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.WhiteColor,
                    ),
                  ),
                )),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/buy/img_product_bg.png"),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  bean.description,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.Text_5E6F88,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _title {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 10.w, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "购买",
            style: TextStyle(
                fontSize: 24,
                color: ColorConstant.TextMainBlack,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(""),
          ),
          GestureDetector(
            onTap: () {
              UiUitls.showChatH5(context);
            },
            child: Image.asset(
              "assets/images/buy/icon_kefu.png",
              height: 40,
              width: 40,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
