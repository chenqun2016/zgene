import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
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
import 'package:zgene/pages/my/my_report_page.dart';
import 'package:zgene/pages/report/report_list_page.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/sp_utils.dart';

import 'home_page.dart';

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
    UmengCommonSdk.onEvent(StatisticsConstant.TAB3_REPORT,
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
    backImgPath = "assets/images/home/bg_home.png";

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
    double alpha = offset / APPBAR_SCROLL_OFFSET;
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
        _tip,
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
              ..add(_bottomBanner),
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

  Widget get _bottomBanner {
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
                SizedBox(
                  height: 128.h,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.archives.length,
                      itemBuilder: (BuildContext context, int index) {
                        var bean = snapshot.data.archives[index];
                        return GestureDetector(
                          onTap: () {
                            CommonUtils.toUrl(
                                context: context,
                                type: bean.linkType,
                                url: bean.linkUrl);
                          },
                          // child: Image.network(
                          //   bannerList[index],
                          //   fit: BoxFit.fill,
                          // ),
                          child: Container(
                            width: 256.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              // gradient: LinearGradient(colors: [
                              //   Color(0xFFFF5D66),
                              //   Color(0xFFFFB254),
                              // ])
                              // image: DecorationImage(
                              //     image: NetworkImage("assets/images/banner.png"))
                            ),
                            margin: EdgeInsets.only(left: 16),
                            child: new CachedNetworkImage(
                              width: 256.w,
                              // 设置根据宽度计算高度
                              height: 128.h,
                              // 图片地址
                              imageUrl: CommonUtils.splicingUrl(bean.imageUrl),
                              // 填充方式为cover
                              fit: BoxFit.fill,

                              errorWidget: (context, url, error) =>
                                  new Container(
                                child: new Image.asset(
                                  'assets/images/home/img_default2.png',
                                  width: 256.w,
                                  height: 128.h,
                                ),
                              ),
                            ),
                            //  FadeInImage.assetNetwork(
                            //     placeholder:
                            //         'assets/images/home/img_default2.png',
                            //     width: 256.w,
                            //     height: 128.h,
                            //     image: CommonUtils.splicingUrl(bean.imageUrl),
                            //     fadeInDuration: TimeUtils.fadeInDuration(),
                            //     fadeOutDuration: TimeUtils.fadeOutDuration(),
                            //     fit: BoxFit.fill,
                            //     imageErrorBuilder:
                            //         (context, error, stackTrace) {
                            //       return Image.asset(
                            //         'assets/images/home/img_default2.png',
                            //         width: 256.w,
                            //         height: 128.h,
                            //         fit: BoxFit.fill,
                            //       );
                            //     }),
                          ),
                        );
                      }),
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
                        crossAxisCount: 3, //条目个数
                        mainAxisSpacing: 16, //主轴间距
                        crossAxisSpacing: 16, //交叉轴间距
                        childAspectRatio: 0.86),
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
            ReportListPage(
              id: bean.id,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: (Column(
          children: [
            new CachedNetworkImage(
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
            // FadeInImage.assetNetwork(
            //     placeholder: 'assets/images/home/img_default2.png',
            //     image: CommonUtils.splicingImageId(bean.id.toString()),
            //     width: 76,
            //     height: 76,
            //     fadeInDuration: TimeUtils.fadeInDuration(),
            //     fadeOutDuration: TimeUtils.fadeOutDuration(),
            //     fit: BoxFit.fill,
            //     imageErrorBuilder: (context, error, stackTrace) {
            //       return Image.asset(
            //         'assets/images/home/img_default2.png',
            //         width: 76,
            //         height: 76,
            //         fit: BoxFit.fill,
            //       );
            //     }),
            Text(
              bean.title,
              style: TextStyle(
                fontSize: 14.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
              ),
            ),
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
      ),
    );
  }

  Widget get _tip {
    return GestureDetector(
      onTap: () {
        if (hasReport) {
          NavigatorUtil.push(context, MyReportPage());
        } else {
          CommonUtils.toUrl(context: context, url: CommonUtils.URL_BUY);
        }
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
              hasReport ? " 查看报告>>" : " 去购买>>",
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
                child: Text(
                  "示例报告",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.TextMainBlack,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16.w,
            top: MediaQuery.of(context).padding.top,
            child: GestureDetector(
              onTap: () async {
                UmengCommonSdk.onEvent(StatisticsConstant.REPORT_PAGE, {
                  StatisticsConstant.KEY_UMENG_L2:
                      StatisticsConstant.REPORT_PAGE_GENDER
                });
                var type = await _showModalBottomSheet();
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
