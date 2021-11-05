import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/event/event_bus.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/archive_des_model.dart';
import 'package:zgene/models/content_model.dart' as cm;
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/buy/ordering_page.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/date_utils.dart';
import 'package:zgene/util/login_base.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/base_web_view.dart';

///产品详情页面
class ProductDetailPage extends BaseWidget {
  ProductDetailPage({Key key}) : super(key: key);

  @override
  _BuyPageState getState() => _BuyPageState();
}

class _BuyPageState extends BaseWidgetState<ProductDetailPage> {
  double appBarAlpha = 0;
  ScrollController _controller = new ScrollController();
  Archive _productDetail;

  List<cm.Archives> _productDetailRecommends;
  Archive stepArchive;
  bool isInActivity = false;
  List<ArchiveTag> tags;
  String countContent; // 倒计时内容
  Timer _timer;
  int seconds = 0;
  var id;

  ///商品库存
  int stock = 0;
  List images = [];
  var colors = [
    ColorConstant.TextMainColor,
    Color(0xFF25D3B2),
    Color(0xFFFFBE00)
  ];

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showBaseHead = false;
    showHead = true;
    isListPage = true;
    setWantKeepAlive = false;
    backImgPath = "assets/images/mine/img_bg_my.png";
    customRightBtnImg = "assets/images/buy/icon_kefu.png";
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      _onScroll(_controller.offset);
    });
  }

  void getStepContent() {
    int stepId = SpUtils().getStorage(SpConstant.appProductStepAid);
    HttpUtils.requestHttp(
      ApiConstant.contentDetail + "/${stepId}",
      method: HttpUtils.GET,
      onSuccess: (result) async {
        ArchiveDesModel model = ArchiveDesModel.fromJson(result);

        setState(() {
          stepArchive = model.archive;
        });
      },
      onError: (code, error) {},
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    cancelTimer();
    bus.off("listMustRefresh");
    super.dispose();
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void startTimer() {
    //设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      setState(() {
        //秒数减一，因为一秒回调一次
        seconds--;
        // print('我在更新界面>>>>>>>>>>>>>> $seconds');
      });
      if (seconds == 0) {
        //倒计时秒数为0，取消定时器
        print('我被取消了');
        cancelTimer();
        // getData();
        bus.emit("listMustRefresh");
        getProductDetail();
      }
    });
  }

  // void getData() async {}

  @override
  Future rightBtnTap(BuildContext context) {
    UiUitls.showChatH5(context);
    return super.rightBtnTap(context);
  }

  void getProductDetail() {
    ArchiveGetHttp(int.parse(id), (result) {
      print(result);
      ArchiveDesModel model = ArchiveDesModel.fromJson(result);
      if (model.archive.limitTime != null) {
        var endtime = model.archive.limitTime.end;
        var starttime = model.archive.limitTime.start;

        // print(time);
        // print(CusDateUtils.getFormatDataS(
        //     timeSamp: time, format: "yyyy-MM-dd HH:mm:ss"));
        // print(11111111);
        if (starttime <= DateTime.now().millisecondsSinceEpoch / 1000 &&
            endtime >= DateTime.now().millisecondsSinceEpoch / 1000) {
          try {
            var date = CusDateUtils.getFormatDataS(
                timeSamp: endtime, format: "yyyy-MM-dd HH:mm:ss");
            var _diffDate = DateTime.parse(date.toString());
            //获取当期时间
            var now = DateTime.now();
            var twoHours = _diffDate.difference(now);
            print(twoHours);
            //获取总秒数，2 分钟为 120 秒
            seconds = twoHours.inSeconds;
            print(seconds);
            isInActivity = true;
            startTimer();
          } catch (e) {
            seconds = 0;
            isInActivity = false;
          }
        }
      }

      setState(() {
        try {
          _productDetail = model.archive;
          tags = _productDetail.tags;
          stock = model.addon?.stock;
          images = model.addon?.images;
        } catch (e) {
          print(e);
        }
      });
    });
  }

  Future<void> getRecommendContent() async {
    Map<String, dynamic> map = new HashMap();
    map['aid'] = id;
    HttpUtils.requestHttp(
      ApiConstant.productDetailRecommends,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        cm.ContentModel contentModel = cm.ContentModel.fromJson(result);
        if (null != contentModel &&
            null != contentModel.archives &&
            contentModel.archives.length > 0) {
          setState(() {
            _productDetailRecommends = contentModel.archives;
            print("_productDetailRecommends");
          });
        }
      },
      onError: (code, error) {},
    );
  }

  @override
  Widget viewPageBody(BuildContext context) {
    if (null == id) {
      //获取路由传的参数
      id = "${ModalRoute.of(context).settings.arguments}";
      getProductDetail();
      getRecommendContent();
      getStepContent();
    }
    return Stack(
      children: [
        _listview,
        if (null != stock && stock > 0) _buyButtom,
      ],
    );
  }

  Widget get _buyButtom {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          height: 89,
          color: Color(0xfcFFFFFF),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                height: 1,
                color: Color(0xffEBEFF1),
              ),
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 38.0),
                    child: Text(
                      "应付：",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.Text_8E9AB,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "¥",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.MainBlueColor,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 1.0),
                    child: Text(
                      isInActivity
                          ? "${CommonUtils.formatMoney(_productDetail.limitCoin)}"
                          : "${CommonUtils.formatMoney(_productDetail.coin)}",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.MainBlueColor,
                      ),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: MaterialButton(
                      minWidth: 142.w,
                      height: 55.h,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      color: ColorConstant.TextMainColor,
                      onPressed: () async {
                        if (!SpUtils()
                            .getStorageDefault(SpConstant.IsLogin, false)) {
                          BaseLogin.login();
                          return;
                        }
                        setState(() {
                          showPicture = false;
                        });
                        await NavigatorUtil.push(
                            context,
                            OrderingPage(
                              product: _productDetail,
                              isInActivity: isInActivity,
                            ));
                        setState(() {
                          showPicture = true;
                        });
                      },
                      child: Text("立即购买",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ));
  }

  var showPicture = true;
  Widget get _listview {
    double h = 348;
    if (null != tags && tags.length > 0) {
      h += 20;
    }
    if (isInActivity) {
      h += 55;
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: h,
            child: Stack(
              children: [
                if (null != images && null != _productDetail) _banner,
                if (null != _productDetail)
                  Positioned(top: 186, left: 0, right: 0, child: _products),
              ],
            ),
          ),
          if (null != stepArchive) _stepView,
          if (null != _productDetailRecommends) _contentList,
          if (null != _productDetail && showPicture) _picture,
        ],
      ),
      controller: _controller,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 89),
    );
  }

  Widget get _banner {
    return Container(
      margin: EdgeInsets.only(left: 17, right: 17, top: 10),
      height: 192,
      alignment: Alignment.topCenter,
      child: Swiper(
        itemCount: images.length,
        autoplay: true,
        loop: false,
        itemWidth: double.infinity,
        itemHeight: 192,
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            width: double.infinity,
            // 设置根据宽度计算高度
            height: 192,
            // 图片地址
            imageUrl: CommonUtils.splicingUrl(images[index]),
            // 填充方式为cover
            fit: BoxFit.fill,

            errorWidget: (context, url, error) => Container(),
          );
        },
        pagination:
            SwiperPagination(margin: const EdgeInsets.fromLTRB(10, 10, 10, 30)),
      ),
    );
  }

  Widget get _products {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 10),
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
          Offstage(
            offstage: !isInActivity,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage("assets/images/buy/icon_buy_detail_top.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 18, left: 16),
                          height: 20,
                          child: Image(
                            image: AssetImage(
                                "assets/images/report/icon_Take_the_time.png"),
                          )),
                      Expanded(child: Container()),
                      Container(
                          margin: EdgeInsets.only(top: 18, right: 16),
                          height: 20,
                          child: takeTheTimeView())
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, left: 0, right: 0),
                    height: 1,
                    decoration: BoxDecoration(color: ColorConstant.line_Gray),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text(
              _productDetail.title,
              style: TextStyle(
                fontSize: 22.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 10, left: 16, right: 16),
            child: Text(
              _productDetail.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorConstant.Text_5E6F88,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  isInActivity
                      ? "¥${CommonUtils.formatMoney(_productDetail.limitCoin)}"
                      : "¥${CommonUtils.formatMoney(_productDetail.coin)}",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.Text_FC4C4E,
                  ),
                ),
              ),
              Offstage(
                offstage: !isInActivity,
                child: Container(
                  margin: EdgeInsets.only(left: 6, right: 16),
                  // padding: EdgeInsets.only(left: 6),
                  child: Text(
                    "¥${CommonUtils.formatMoney(_productDetail.coin)}",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                      color: ColorConstant.Text_8E9AB,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (null != tags)
            Padding(
              padding: const EdgeInsets.only(
                  top: 12, left: 16, right: 16, bottom: 14),
              child: Row(
                children: tags.map((e) => _tagItem(e)).toList(),
              ),
            )
        ],
      ),
    );
  }

  Widget takeTheTimeView() {
    return Container(
        child: Row(
      children: [
        Container(
          height: 20,
          // width: 20,
          child: Center(
            child: Text(
              "限时折扣",
              style: TextStyle(
                color: ColorConstant.TextRedColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 5),
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: ColorConstant.TextRedColor,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Center(
            child: Text(
              TimeUtils.constructTime_day(seconds),
              style: TextStyle(
                color: ColorConstant.WhiteColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: Text(
              "天",
              style: TextStyle(
                color: ColorConstant.TextRedColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: ColorConstant.TextRedColor,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Center(
            child: Text(
              TimeUtils.constructTime_hour(seconds),
              style: TextStyle(
                color: ColorConstant.WhiteColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: Text(
              "时",
              style: TextStyle(
                color: ColorConstant.TextRedColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: ColorConstant.TextRedColor,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Center(
            child: Text(
              TimeUtils.constructTime_minute(seconds),
              style: TextStyle(
                color: ColorConstant.WhiteColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: Text(
              "分",
              style: TextStyle(
                color: ColorConstant.TextRedColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: ColorConstant.TextRedColor,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Center(
            child: Text(
              TimeUtils.constructTime_second(seconds),
              style: TextStyle(
                color: ColorConstant.WhiteColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          height: 20,
          width: 20,
          child: Center(
            child: Text(
              "秒",
              style: TextStyle(
                color: ColorConstant.TextRedColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _tagItem(ArchiveTag tag) {
    var indexOf = tags.indexOf(tag);
    var colorIndex = indexOf % colors.length;
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.fromLTRB(7, 1, 7, 3),
      decoration: BoxDecoration(
        color: colors[colorIndex].withAlpha(30),
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Text(
        "${tag.name}",
        style: TextStyle(
          fontSize: 11,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: colors[colorIndex],
        ),
      ),
    );
  }

  Widget get _stepView => Container(
        margin: EdgeInsets.only(top: 8),
        child: InkWell(
          onTap: () {
            CommonUtils.toUrl(
                context: context,
                type: stepArchive.linkType,
                url: stepArchive.linkUrl,
                archives: stepArchive);
          },
          child: CachedNetworkImage(
            width: double.infinity,
            // 设置根据宽度计算高度
            height: (157 / 375) * (MediaQuery.of(context).size.width),
            // 图片地址
            imageUrl: CommonUtils.splicingUrl(stepArchive.imageUrl),
            // 填充方式为cover
            fit: BoxFit.fill,
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/home/img_default2.png"),
          ),
        ),
      );

  Widget get _picture {
    return Container(
      color: Colors.white,
      width: double.infinity,
      margin: EdgeInsets.only(top: 8),
      child: PlatformUtils.isWeb
          ? CachedNetworkImage(
              width: double.infinity,
              imageUrl:
                  "https://www.z-gene.cn/public/statics/img/5653950028.jpg",
              // 填充方式为cover
              fit: BoxFit.cover,
            )
          : BasePageWebView(
              url: ApiConstant.getH5DetailUrl(_productDetail.id.toString()),
            ),
    );
  }

  _onScroll(double offset) {
    if (offset < APPBAR_SCORLL_OFFSET) {
      trans = offset.toInt();
      if (trans < 0) trans = 0;
      setState(() {});
    } else {
      if (trans != APPBAR_SCORLL_OFFSET) {
        trans = APPBAR_SCORLL_OFFSET;
        setState(() {});
      }
    }
  }

  get _contentList => Container(
        margin: EdgeInsets.only(top: 8),
        color: Colors.white,
        child: ListView.builder(
          itemCount: _productDetailRecommends.length,
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var productDetailRecommend = _productDetailRecommends[index];
            if (0 == productDetailRecommend.viewStyle) {
              return _videoItem(productDetailRecommend);
            }
            return getContentItem(productDetailRecommend);
          },
        ),
      );

  Widget _videoItem(cm.Archives item) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          CommonUtils.toUrl(
              context: context,
              type: item.linkType,
              url: item.linkUrl,
              archives: item);
        },
        child: PhysicalModel(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: new CachedNetworkImage(
            width: double.infinity,
            // 设置根据宽度计算高度
            height: (168 / 345) * (MediaQuery.of(context).size.width - 30),
            // 图片地址
            imageUrl: CommonUtils.splicingUrl(item.imageUrl),
            // 填充方式为cover
            fit: BoxFit.fill,
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/home/img_default2.png"),
          ),
        ),
      ),
    );
  }

  Widget getContentItem(cm.Archives item) {
    return InkWell(
      onTap: () {
        CommonUtils.toUrl(
            context: context,
            type: item.linkType,
            url: item.linkUrl,
            archives: item);
      },
      child: Container(
        margin: EdgeInsets.only(top: 16),
        height: 80,
        child: Stack(
          children: [
            Positioned(
                left: 0,
                top: 5,
                right: 150,
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.TextMainBlack,
                  ),
                )),
            Positioned(
              left: 0,
              bottom: 5,
              child: Text(
                //TODO
                // item.category?.categoryName,
                "Z基因研究院",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.Text_5E6F88,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: PhysicalModel(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(14)),
                clipBehavior: Clip.antiAlias,
                child: new CachedNetworkImage(
                  height: 80,
                  width: 134,
                  // 图片地址
                  imageUrl: CommonUtils.splicingUrl(item.imageUrl),
                  // 填充方式为cover
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
