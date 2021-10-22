import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/constant/statistics_constant.dart';
import 'package:zgene/event/event_bus.dart';
import 'package:zgene/http/base_response.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/category_model.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/pages/report/report_level_1_page.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/umeng_utils.dart';

///首页报告
class ReportPage extends BaseWidget {
  String id;

  ReportPage({Key key, this.id}) : super(key: key) {
    print("ReportPage super  ");
  }

  @override
  BaseWidgetState<BaseWidget> getState() => _ReportPageState();
}

class _ReportPageState extends BaseWidgetState<ReportPage> {
  List<Categories> categories = [];
  ScrollController _controller = new ScrollController();
  EasyRefreshController _easyController;

  int jingxuan = 15;

  ///7 : 女    6：男
  var type = 7;

  //顶部渐变
  double appBarAlphas = 0;

  bool hasReport = false;
  HashMap cache = HashMap<int, dynamic>();

  @override
  void dispose() {
    bus.off("ReportPage");
    _controller.dispose();
    super.dispose();
  }

  @override
  void pageWidgetInitState() {
    UmengUtils.onEvent(StatisticsConstant.TAB3_REPORT,
        {StatisticsConstant.KEY_UMENG_L2: StatisticsConstant.TAB3_REPORT_IMP});

    if (null != widget.id) {
      type = int.parse(widget.id);
    }
    bus.on("ReportPage", (arg) {
      if (null != arg) {
        int argType = int.parse(arg);
        if (type != argType) {
          setState(() {
            type = argType;
            _getReport();
          });
        }
      }
    });

    super.pageWidgetInitState();
    showBaseHead = false;
    showHead = false;
    isListPage = true;
    setWantKeepAlive = true;
    backImgPath = "assets/images/mine/icon_contant_us_back.png";

    _easyController = EasyRefreshController();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      _onScroll(_controller.offset);
    });
    _getReport();
    _getOwnerReport();
  }

  _getReport() {
    CategoriesGetHttp(type, (result) {
      var categoryModel = CategoryModel.fromJson(result);
      if (null != categoryModel) {
        setState(() {
          categories = categoryModel.categories;
        });
      }
    });
  }

  Future<dynamic> _getReportItem(id) async {
    try {
      Map<String, dynamic> map = new HashMap();
      map['cid'] = id.toString();
      Dio dio = await HttpUtils.createInstance();
      Response response =
          await dio.get(ApiConstant.contentList, queryParameters: map);
      var responseString = json.decode(response.toString());
      var responseResult = BaseResponse.fromJson(responseString);
      log('响应数据item：${id.toString()}//' + response.toString());
      ContentModel contentModel = ContentModel.fromJson(responseResult.result);
      // cache[id] = contentModel;
      return contentModel;
    } catch (e) {
      print(e);
    }
    return;
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCORLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    if (appBarAlphas != alpha) {
      setState(() {
        appBarAlphas = alpha;
      });
    }
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        _appBar,
        if (!hasReport) _tip,
        Expanded(
          // child: EasyRefresh(
          //   // 是否开启控制结束加载
          //   enableControlFinishLoad: false,
          //   firstRefresh: true,
          //   // 控制器
          //   bottomBouncing: false,
          //   controller: _easyController,
          //   header: RefreshConfigUtils.classicalHeader(),
          child: ListView(
            controller: _controller,
            shrinkWrap: true,
            // physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
            children: categories.map((e) {
              return _items(e);
            }).toList()
              ..insert(0, _topBanner),
          ),
          //   //下拉刷新事件回调
          //   onRefresh: () async {
          //     // page = 1;
          //     // // 获取数据
          //     cache.clear();
          //     _getReport();
          //     _getOwnerReport();
          //     // await Future.delayed(Duration(seconds: 1), () {
          //     // 重置刷新状态 【没错，这里用的是resetLoadState】
          //     if (_easyController != null) {
          //       _easyController.resetLoadState();
          //     }
          //     // });
          //   },
          // ),
        ),
      ]),
    );
  }

  Widget get _topBanner {
    var fut;
    if (cache.containsKey(jingxuan)) {
      print("15");
      fut = cache[jingxuan];
    } else {
      fut = _getReportItem(jingxuan);
      cache[jingxuan] = fut;
    }
    return FutureBuilder(
      future: fut,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 15, top: 24, right: 15, bottom: 10),
                  child: Text(
                    snapshot.data.archives[0].category.categoryName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.TextMainBlack,
                    ),
                  ),
                ),
                Container(
                  height: 168,
                  padding: EdgeInsets.only(left: 15),
                  child: Swiper(
                    itemCount: snapshot.data.archives.length,
                    autoplay: true,
                    loop: false,
                    containerWidth: double.infinity,
                    itemWidth: 343,
                    itemHeight: 168,
                    itemBuilder: (BuildContext context, int index) {
                      var bean = snapshot.data.archives[index];
                      return GestureDetector(
                        onTap: () {
                          CommonUtils.toUrl(
                              context: context,
                              type: bean.linkType,
                              url: bean.linkUrl);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 15),
                          child: CachedNetworkImage(
                            // 图片地址
                            imageUrl: CommonUtils.splicingUrl(bean.imageUrl),
                            // 填充方式为cover
                            fit: BoxFit.fill,
                            errorWidget: (context, url, error) => new Container(
                              child: new Image.asset(
                                'assets/images/home/img_default2.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return Text("");
      },
    );
  }

  Widget _items(Categories category) {
    var fut;
    if (cache.containsKey(category.id)) {
      print(category.id.toString());
      fut = cache[category.id];
    } else {
      fut = _getReportItem(category.id);
      cache[category.id] = fut;
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 24),
            child: Text(
              category.categoryName,
              style: TextStyle(
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          FutureBuilder(
            future: fut,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return GridView.builder(
                    padding: EdgeInsets.fromLTRB(16, 15, 16, 0),
                    physics: NeverScrollableScrollPhysics(),
                    //增加
                    shrinkWrap: true,
                    //增加
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //条目个数
                        mainAxisSpacing: 16, //主轴间距
                        crossAxisSpacing: 16, //交叉轴间距
                        childAspectRatio: 2.1),
                    itemCount: snapshot.data.archives.length,
                    itemBuilder: (context, i) {
                      return _item(snapshot.data.archives[i]);
                    });
              }
              return Text("");
            },
          ),
        ],
      ),
    );
  }

  Widget _item(Archives bean) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            ReportLevel1Page(
              id: bean.id,
            ));
      },
      child: Container(
        padding: EdgeInsets.only(left: 13, right: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bean.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.TextMainBlack,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 6,
                ),
                if (bean.keywords != null && bean.keywords.isNotEmpty)
                  Text(
                    bean.keywords,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.Text_8E9AB,
                    ),
                  ),
              ],
            )),
            CachedNetworkImage(
              width: 76,
              // 设置根据宽度计算高度
              height: 76,
              // 图片地址
              imageUrl: CommonUtils.splicingImageId(bean.id.toString()),
              // 填充方式为cover
              fit: BoxFit.fill,
              errorWidget: (context, url, error) => new Container(
                child: new Image.asset(
                  'assets/images/home/img_default2.png',
                  height: 76,
                  width: 76,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _tip {
    return GestureDetector(
      onTap: () {
        CommonUtils.toUrl(context: context, url: CommonUtils.URL_BUY);
      },
      child: Container(
        width: double.infinity,
        height: 32,
        decoration: BoxDecoration(color: ColorConstant.TextMainColor_10per),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "此示例报告[标准/${type == 7 ? "女" : "男"}]，请以真实检测数据为准。",
              style: TextStyle(
                  fontSize: 13,
                  color: ColorConstant.TextMainColor,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              " 去购买>>",
              style: TextStyle(
                  fontSize: 13,
                  color: ColorConstant.bg_EA4335,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget get _appBar {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB((appBarAlphas * 255).toInt(), 255, 255, 255),
      ),
      height: 55.h + MediaQuery.of(context).padding.top,
      child: Stack(
        children: [
          Positioned(
            left: 16.w,
            top: MediaQuery.of(context).padding.top,
            child: Container(
              height: 55.h,
              child: Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: hasReport ? "Andy" : "示例报告",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.TextMainBlack,
                    ),
                  ),
                  if (hasReport)
                    TextSpan(
                      text: "的报告—",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.TextMainBlack,
                      ),
                    ),
                  if (hasReport)
                    TextSpan(
                      text: "青春版",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.Text_5FC88F,
                      ),
                    ),
                ])),
              ),
            ),
          ),
          Positioned(
            right: 16.w,
            top: MediaQuery.of(context).padding.top,
            child: GestureDetector(
              onTap: () async {
                UmengUtils.onEvent(StatisticsConstant.REPORT_PAGE, {
                  StatisticsConstant.KEY_UMENG_L2:
                      StatisticsConstant.REPORT_PAGE_GENDER
                });
                // await _showModalBottomSheet();
                await _switchReport();
              },
              child: Container(
                height: 55.h,
                child: Center(
                  child: Image.asset(
                    "assets/images/report/icon_qiehuan.png",
                    height: 36,
                    width: 36,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 弹出底部菜单列表模态对话框
  Future<int> _showModalBottomSheet() async {
    return await showModalBottomSheet<int>(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(left: 22, top: 20, right: 22),
          height: 230,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "切换检测人",
                style: TextStyle(
                    fontSize: 18,
                    color: ColorConstant.TextMainBlack,
                    fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  if (type == 7) {
                    setState(() {
                      type = 6;
                    });
                    _getReport();
                  }
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    "标准/男",
                    style: TextStyle(
                        fontSize: 18,
                        color: ColorConstant.TextMainBlack,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: ColorConstant.Divider,
              ),
              GestureDetector(
                onTap: () {
                  if (type == 6) {
                    setState(() {
                      type = 7;
                    });
                    _getReport();
                  }
                  Navigator.of(context).pop();
                },
                child: Container(
                    height: 60,
                    color: Colors.transparent,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "标准/女",
                      style: TextStyle(
                          fontSize: 18,
                          color: ColorConstant.TextMainBlack,
                          fontWeight: FontWeight.w600),
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  var reports = [
    "andy",
    "张飞",
    "李白",
    "嫦娥",
  ];
  var currentReport = 0;
// 弹出底部菜单列表模态对话框
  Future<int> _switchReport() async {
    var size = reports.length > 9 ? 9 : reports.length;
    var height = (56 + size * 70).toDouble();
    return await showModalBottomSheet<int>(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          height: height,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "切换报告",
                  style: TextStyle(
                      fontSize: 18,
                      color: ColorConstant.TextMainBlack,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: height - 56,
                margin: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFEDF3F6),
                    Color(0xFFEBEFF1).withAlpha(1),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                ),
                child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    children: reports.map((e) {
                      var index = reports.indexOf(e);
                      var name = e;
                      if (currentReport == index) {
                        name = "$e（当前）";
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          currentReport = index;
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 22, bottom: 22),
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: currentReport == index
                                  ? ColorConstant.TextMainColor
                                  : ColorConstant.TextMainBlack,
                            ),
                          ),
                        ),
                      );
                    }).toList()),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getOwnerReport() {
    if (SpUtils().getStorageDefault(SpConstant.IsLogin, false))
      HttpUtils.requestHttp(
        ApiConstant.reports,
        method: HttpUtils.GET,
        onSuccess: (result) async {
          List l = result;
          if (null != l && l.length > 0) {
            setState(() {
              hasReport = true;
            });
          }
        },
      );
  }
}
