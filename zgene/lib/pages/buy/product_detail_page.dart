import 'dart:collection';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/archive_des_model.dart';
import 'package:zgene/models/content_model.dart' as cm;
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/buy/ordering_page.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
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
  List<ArchiveTag> tags;

  var id;

  ///商品库存
  int stock = 0;
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
    super.dispose();
  }

  @override
  Future rightBtnTap(BuildContext context) {
    UiUitls.showChatH5(context);
    return super.rightBtnTap(context);
  }

  void getProductDetail() {
    ArchiveGetHttp(int.parse(id), (result) {
      ArchiveDesModel model = ArchiveDesModel.fromJson(result);
      setState(() {
        try {
          _productDetail = model.archive;
          tags = _productDetail.tags;
          stock = model.addon?.stock;
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
          color: Color(0xf8FFFFFF),
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
                      "${CommonUtils.formatMoney(_productDetail.coin)}",
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

  Widget get _listview {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (null != _productDetail) _banner,
          if (null != _productDetail) _products,
          if (null != stepArchive) _stepView,
          if (null != _productDetailRecommends) _contentList,
          if (null != _productDetail) _picture,
        ],
      ),
      controller: _controller,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 89),
    );
  }

  Widget get _banner {
    return ClipRect(
      child: Container(
        margin: EdgeInsets.only(left: 17, right: 17, top: 10),
        height: 170,
        alignment: Alignment.topCenter,
        child: Hero(
          tag: _productDetail.id.toString(),
          child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/home/img_default2.png',
              image: CommonUtils.splicingUrl(_productDetail.imageUrl),
              width: double.infinity,
              height: 192,
              fadeInDuration: TimeUtils.fadeInDuration(),
              fadeOutDuration: TimeUtils.fadeOutDuration(),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              imageErrorBuilder: (context, error, stackTrace) {
                return Text("");
              }),
        ),
        // new CachedNetworkImage(
        //   width: 343,
        //   // 设置根据宽度计算高度
        //   height: 192,
        //   // 图片地址
        //   imageUrl: CommonUtils.splicingUrl(_productDetail.imageUrl),
        //   // 填充方式为cover
        //   fit: BoxFit.fill,
        //
        //   errorWidget: (context, url, error) => new Container(
        //     child: new Image.asset(
        //       'assets/images/home/img_default2.png',
        //       height: 343,
        //       width: 192,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget get _products {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 20, 16, 22),
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
            padding: EdgeInsets.only(top: 12, bottom: 10),
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
          Text(
            "¥${CommonUtils.formatMoney(_productDetail.coin)}",
            style: TextStyle(
              fontSize: 22.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: ColorConstant.Text_FC4C4E,
            ),
          ),
          if (null != tags)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: tags.map((e) => _tagItem(e)).toList(),
              ),
            )
        ],
      ),
    );
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
        margin: EdgeInsets.only(top: 16),
        child: InkWell(
          onTap: () {
            CommonUtils.toUrl(
                context: context,
                type: stepArchive.linkType,
                url: stepArchive.linkUrl);
          },
          child: CachedNetworkImage(
            width: double.infinity,
            // 设置根据宽度计算高度
            height: 155,
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
      margin: EdgeInsets.only(top: 16),
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
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: ListView.builder(
          itemCount: _productDetailRecommends.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(15),
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
              context: context, type: item.linkType, url: item.linkUrl);
        },
        child: PhysicalModel(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: new CachedNetworkImage(
            width: double.infinity,
            // 设置根据宽度计算高度
            height: 168,
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
            context: context, type: item.linkType, url: item.linkUrl);
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
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
