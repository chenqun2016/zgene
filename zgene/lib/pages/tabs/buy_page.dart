import 'dart:collection';

import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/my/ordering_page.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/login_base.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/refresh_config_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/base_web_view.dart';

const APPBAR_SCROLL_OFFSET = 50;
const APPBAR_SCROLL_OFFSET2 = 400;

///首页购买页面
class BuyPage extends BaseWidget {
  @override
  _BuyPageState getState() => _BuyPageState();
}

class _BuyPageState extends BaseWidgetState<BuyPage> {
  double appBarAlpha = 0;
  bool showBuyButtom = false;
  EasyRefreshController _easyController;
  ScrollController _controller = new ScrollController();
  Archives _productDetail;
  static ValueKey key = ValueKey('key_0');

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showBaseHead = false;
    showHead = false;
    isListPage = true;
    setWantKeepAlive = true;
    backImgPath = "assets/images/mine/img_bg_my.png";
    _easyController = EasyRefreshController();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      _onScroll(_controller.offset);
    });
    HomeGetHttp();
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  Future<void> HomeGetHttp() async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }
    EasyLoading.show(status: 'loading...');

    Map<String, dynamic> map = new HashMap();
    map['chid'] = 5;
    HttpUtils.requestHttp(
      ApiConstant.contentList,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        EasyLoading.dismiss();
        ContentModel contentModel = ContentModel.fromJson(result);
        if (null != contentModel &&
            null != contentModel.archives &&
            contentModel.archives.length > 0) {
          setState(() {
            _productDetail = contentModel.archives[0];
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
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          // child: EasyRefresh(
          //   // 是否开启控制结束加载
          //   enableControlFinishLoad: false,
          //   firstRefresh: true,
          //   // 控制器
          //   controller: _easyController,
          //   header: RefreshConfigUtils.classicalHeader(),
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
          // ),
        ),
        _appBar
      ],
    );
  }

  Widget get _listview {
    return ListView(
      controller: _controller,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _title,
        if (null != _productDetail) _banner,
        if (null != _productDetail) _products,
        if (null != _productDetail) _picture,
      ],
    );
  }

  Widget get _banner {
    return ClipRect(
      child: Container(
        width: 343,
        height: 172,
        alignment: Alignment.topCenter,
        child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/home/img_default2.png',
            image: CommonUtils.splicingUrl(_productDetail.imageUrl),
            width: 343,
            height: 192,
            fadeInDuration: TimeUtils.fadeInDuration(),
            fadeOutDuration: TimeUtils.fadeOutDuration(),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/home/img_default2.png',
                width: double.infinity,
                height: 192,
                fit: BoxFit.fill,
              );
            }),
      ),
    );
  }

  Widget get _products {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _productDetail.title,
            style: TextStyle(
              fontSize: 22.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: ColorConstant.TextMainBlack,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 16),
            child: Text(
              _productDetail.description,
              style: TextStyle(
                fontSize: 15.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorConstant.Text_5E6F88,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "¥${CommonUtils.formatMoney(_productDetail.coin)}",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.Text_FC4C4E,
                  ),
                ),
                flex: 1,
              ),
              MaterialButton(
                minWidth: 142.w,
                height: 44.h,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: ColorConstant.TextMainColor,
                onPressed: () {
                  if (!SpUtils().getStorageDefault(SpConstant.IsLogin, false)) {
                    BaseLogin.login();
                    return;
                  }
                  NavigatorUtil.push(
                      context,
                      OrderingPage(
                        product: _productDetail,
                      ));
                },
                child: Text("立即购买",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget get _picture {
    return Container(
      color: Colors.white,
      width: double.infinity,
      margin: EdgeInsets.only(top: 16, bottom: 56),
      child: PlatformUtils.isWeb
          ? EasyWebView(
              onLoaded: () {},
              src: ApiConstant.getH5DetailUrl(_productDetail.id.toString()),
              key: key,
              isHtml: false,
              isMarkdown: false,
              webAllowFullScreen: false,
              convertToWidgets: false,
              widgetsTextSelectable: false,
              webNavigationDelegate: (_) => true
                  ? WebNavigationDecision.prevent
                  : WebNavigationDecision.navigate,
              // width: 300,
              height: 3000,
            )
          : BasePageWebView(
              url: ApiConstant.getH5DetailUrl(_productDetail.id.toString()),
            ),
    );
  }

  Widget get _title {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 10.w, bottom: 13),
      child: Text(
        "购买",
        style: TextStyle(
            fontSize: 24,
            color: ColorConstant.TextMainBlack,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget get _appBar {
    return Opacity(
      opacity: appBarAlpha,
      child: Container(
        color: Colors.white,
        height: 55.h + MediaQuery.of(context).padding.top,
        child: Stack(
          children: [
            Positioned(
              left: 80.w,
              right: 80.w,
              top: MediaQuery.of(context).padding.top,
              child: Container(
                height: 55.h,
                child: Center(
                  child: Text(
                    "购买",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.TextMainBlack,
                    ),
                  ),
                ),
              ),
            ),
            if (showBuyButtom)
              Positioned(
                  top: MediaQuery.of(context).padding.top,
                  right: 16.w,
                  child: Container(
                    height: 55.h,
                    alignment: Alignment.center,
                    child: MaterialButton(
                      minWidth: 76.w,
                      height: 28.h,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: ColorConstant.TextMainColor,
                      onPressed: () {
                        if (!SpUtils()
                            .getStorageDefault(SpConstant.IsLogin, false)) {
                          BaseLogin.login();
                          return;
                        }

                        NavigatorUtil.push(
                            context,
                            OrderingPage(
                              product: _productDetail,
                            ));
                      },
                      child: Text("立即购买",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ))
          ],
        ),
      ),
    );
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    if (appBarAlpha != alpha) {
      setState(() {
        appBarAlpha = alpha;
      });
      print(appBarAlpha);
    }
    bool showLittleButtom = offset > APPBAR_SCROLL_OFFSET2;
    if (showLittleButtom != showBuyButtom) {
      setState(() {
        showBuyButtom = showLittleButtom;
      });
    }
  }
}
