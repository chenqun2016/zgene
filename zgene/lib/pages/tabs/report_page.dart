import 'dart:collection';

import 'package:base/widget/base_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/constant/statistics_constant.dart';
import 'package:zgene/event/event_bus.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/jinxuan_model.dart';
import 'package:zgene/models/report_page_model.dart';
import 'package:zgene/models/report_sample_model.dart';
import 'package:zgene/models/report_summary_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/report/report_level_1_page.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/umeng_utils.dart';

///7 : 女    6：男
var genderType = 7;

///当前选中的 采集器编号
var currentSerialNum;

///首页报告
class ReportPage extends StatefulWidget {
  String id;
  String scope;
  String serialNum;
  ReportPage({Key key}) : super(key: key) {
    print("ReportPage super  ");
  }

  @override
  BaseWidgetState createState() => _ReportPageState();
}

class _ReportPageState extends BaseWidgetState<ReportPage> {
  List<ReportSummaryModel> categories = [];
  List<JinxuanModel> jinxuanDatas = [];
  ScrollController _controller = new ScrollController();
  EasyRefreshController _easyController;

  int jingxuan = 15;

  //顶部渐变
  double appBarAlphas = 0;

  var serialNumFromRemote;

  var scope;

  ///示例报告 男，女
  List<ReportSampleModel> reportSamples = [];

  @override
  void dispose() {
    bus.off("ReportPage");
    bus.off(CommonConstant.refreshMine);
    _controller.dispose();
    super.dispose();
  }

  @override
  void customInitState() {
    UmengUtils.onEvent(StatisticsConstant.TAB3_REPORT,
        {StatisticsConstant.KEY_UMENG_L2: StatisticsConstant.TAB3_REPORT_IMP});
    scope = widget.scope;
    serialNumFromRemote = widget.serialNum;
    if (null != widget.id) {
      genderType = int.parse(widget.id);
    }
    bus.on("ReportPage", (arg) {
      if (null != arg) {
        try {
          var argType = arg["id"];
          if (null != argType) {
            argType = int.parse(arg["id"]);
            if (genderType != argType) {
              setState(() {
                genderType = argType;
                Map<String, dynamic> map = new HashMap();
                map['sample'] = genderType == 6 ? "male" : "female";
                _getReportContent(map);
              });
            }
          }
          var scope = arg["scope"];
          if (null != scope) {
            categories.forEach((e) {
              if (e.code == scope) {
                NavigatorUtil.push(
                    context,
                    ReportLevel1Page(
                      type: genderType == 6 ? "male" : "female",
                      id: e.code,
                      summaryModel: e,
                      serialNum: collectors.length > 0
                          ? collectors[currentCollector].serialNum
                          : null,
                    ));
              }
            });
          }

          var serialNum = arg["serialNum"];
          if (null != serialNum) {
            serialNumFromRemote = serialNum;
            _getCollector();
          }
        } catch (e) {
          print("数据转化失败" + e);
        }
      }
    });
    bus.on(CommonConstant.refreshMine, (event) {
      print("refreshReport");
      currentSerialNum = null;
      _getCollector();
    });

    super.customInitState();
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
  Widget customBuildBody(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        _appBar,
        if (collectors.length <= 0 && reportSamples.length > 0) _tip,
        Expanded(
          child: EasyRefresh(
            // 是否开启控制结束加载
            enableControlFinishLoad: false,
            firstRefresh: true,
            // 控制器
            bottomBouncing: false,
            controller: _easyController,
            header: BallPulseHeader(),
            child: SingleChildScrollView(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: _items(),
            ),
            //   //下拉刷新事件回调
            onRefresh: () async {
              // page = 1;
              // // 获取数据
              _getCollector();
              // await Future.delayed(Duration(seconds: 1), () {
              // 重置刷新状态 【没错，这里用的是resetLoadState】
              if (_easyController != null) {
                _easyController.resetLoadState();
              }
              // });
            },
          ),
        ),
      ]),
    );
  }

  Widget get _topBanner {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15, top: 24, right: 15, bottom: 10),
          child: Text(
            "精选报告",
            style: TextStyle(
              fontSize: 18.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: ColorConstant.TextMainBlack,
            ),
          ),
        ),
        SizedBox(
          height: 152.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: jinxuanDatas.length,
              itemBuilder: (BuildContext context, int index) {
                var bean = jinxuanDatas[index];
                return GestureDetector(
                  onTap: () {
                    CommonUtils.toUrl(
                        context: context, type: 2, url: bean.router);
                  },
                  child: Container(
                    width: 310.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    margin: index == jinxuanDatas.length - 1
                        ? EdgeInsets.only(left: 16, right: 16)
                        : EdgeInsets.only(left: 16),
                    child: Stack(
                      children: [
                        PhysicalModel(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.transparent,
                          child: CachedNetworkImage(
                            width: 310.w,
                            // 设置根据宽度计算高度
                            height: 152.h,
                            // 图片地址
                            imageUrl: CommonUtils.splicingUrl(bean.bgImg),
                            // 填充方式为cover
                            fit: BoxFit.fill,

                            errorWidget: (context, url, error) => new Container(
                              child: new Image.asset(
                                'assets/images/home/img_default2.png',
                                width: 310.w,
                                height: 152.h,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 20,
                            left: 16,
                            width: 180,
                            child: Text(bean.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.WhiteColor,
                                ))),
                        Positioned(
                            left: 16,
                            bottom: 20,
                            child: Container(
                              height: 28,
                              width: 76,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text("查看报告",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.WhiteColor,
                                  )),
                            )),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget _items() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (null != jinxuanDatas && jinxuanDatas.length > 0) _topBanner,
        Padding(
          padding: EdgeInsets.only(left: 16, top: 24),
          child: Text(
            "探索基因蓝图",
            style: TextStyle(
              fontSize: 18.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: ColorConstant.TextMainBlack,
            ),
          ),
        ),
        GridView.builder(
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
            itemCount: categories.length,
            itemBuilder: (context, i) {
              return _item(categories[i]);
            }),
      ],
    );
  }

  Widget _item(ReportSummaryModel bean) {
    return GestureDetector(
      onTap: () {
        if ("更多报告" == bean.name) {
          return;
        }
        UmengUtils.onEvent(StatisticsConstant.REPORT_PAGE, {
          StatisticsConstant.KEY_UMENG_L2:
              StatisticsConstant.REPORT_PAGE_ + "${bean.code}"
        });
        NavigatorUtil.push(
            context,
            ReportLevel1Page(
              type: genderType == 6 ? "male" : "female",
              id: bean.code,
              summaryModel: bean,
              serialNum: collectors.length > 0
                  ? collectors[currentCollector].serialNum
                  : null,
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
                  bean.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: "更多报告" == bean.name
                        ? ColorConstant.Text_8E9AB
                        : ColorConstant.TextMainBlack,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    "更多报告" == bean.name ? "等待解锁" : "共${bean.count}项",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.Text_8E9AB,
                    ),
                  ),
                ),
              ],
            )),
            CachedNetworkImage(
              width: 76,
              // 设置根据宽度计算高度
              height: 76,
              // 图片地址
              imageUrl: CommonUtils.splicingUrl(bean.img.toString()),
              // 填充方式为cover
              fit: BoxFit.fill,
              errorWidget: (context, url, error) => Text(""),
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
              reportSamples[sampleReportIndex].msg,
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
                    text: collectors.length > 0
                        ? collectors[currentCollector].targetName
                        : "示例报告",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.TextMainBlack,
                    ),
                  ),
                  if (collectors.length > 0)
                    TextSpan(
                      text: "的报告—",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.TextMainBlack,
                      ),
                    ),
                  if (collectors.length > 0)
                    TextSpan(
                      text: _getSerialName(
                          collectors[currentCollector].serialNum),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.TextMainColor,
                      ),
                    ),
                ])),
              ),
            ),
          ),
          if (collectors.length > 0 || reportSamples.length > 1)
            Positioned(
              right: 16.w,
              top: MediaQuery.of(context).padding.top,
              child: GestureDetector(
                onTap: () async {
                  UmengUtils.onEvent(StatisticsConstant.REPORT_PAGE, {
                    StatisticsConstant.KEY_UMENG_L2:
                        StatisticsConstant.REPORT_PAGE_GENDER
                  });
                  if (collectors.length > 0) {
                    await _switchReport();
                  } else {
                    await _showModalBottomSheet();
                  }
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

  String _getSerialName(String serialNum) {
    if (null != serialNum) {
      var substring = serialNum.substring(0, 1);
      if ("J" == substring) {
        return "健康版";
      }
      if ("B" == substring) {
        return "全基因";
      }
    }
    return "青春版";
  }

  var sampleReportIndex = 0;
  // 弹出底部菜单列表模态对话框
  Future<int> _showModalBottomSheet() async {
    return await showModalBottomSheet<int>(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          height: 230,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                child: Text(
                  "切换报告",
                  style: TextStyle(
                      fontSize: 18,
                      color: ColorConstant.TextMainBlack,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
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
                child: Column(
                  children: reportSamples
                      .map((e) => GestureDetector(
                            onTap: () {
                              sampleReportIndex = reportSamples.indexOf(e);
                              if (e.sex == 'female') {
                                genderType = 7;
                              }
                              if (e.sex == 'male') {
                                genderType = 6;
                              }
                              setState(() {});
                              Map<String, dynamic> map = new HashMap();
                              map['sample'] = e.sex;
                              _getReportContent(map);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 60,
                              color: Colors.transparent,
                              margin: EdgeInsets.only(top: 10),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${e.name}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: e.sex ==
                                                (genderType == 6
                                                    ? "male"
                                                    : "female")
                                            ? ColorConstant.TextMainColor
                                            : ColorConstant.TextMainBlack,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  if (e.sex ==
                                      (genderType == 6 ? "male" : "female"))
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 2),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 20,
                                        color: ColorConstant.TextMainColor,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

// 弹出底部菜单列表模态对话框
  Future<int> _switchReport() async {
    var size = collectors.length > 9 ? 9 : collectors.length;
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
                height: height - 57,
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
                    children: collectors.map((e) {
                      var index = collectors.indexOf(e);

                      return InkWell(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          currentCollector = index;
                          _getReport();
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                e.targetName,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  color: currentCollector == index
                                      ? ColorConstant.TextMainColor
                                      : ColorConstant.TextMainBlack,
                                ),
                              ),
                              if (currentCollector == index)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 2),
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 20,
                                    color: ColorConstant.TextMainColor,
                                  ),
                                )
                            ],
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

  List<ReportPageModel> collectors = [];
  var currentCollector = 0;

  void _getCollector() async {
    collectors.clear();
    currentCollector = 0;

    if (SpUtils().getStorageDefault(SpConstant.IsLogin, false)) {
      Map<String, dynamic> map = new HashMap();
      map['page'] = 1;
      map['size'] = 100;

      HttpUtils.requestHttp(
        ApiConstant.collector_list,
        method: HttpUtils.GET,
        parameters: map,
        isNeedCache: true,
        onSuccess: (result) async {
          List l = result;
          l.forEach((element) {
            var reportPageModel = ReportPageModel.fromJson(element);
            if (reportPageModel.status == 80) {
              collectors.add(reportPageModel);
              if (null != serialNumFromRemote &&
                  serialNumFromRemote == reportPageModel.serialNum) {
                currentCollector = collectors.indexOf(reportPageModel);
                serialNumFromRemote = null;
              }
            }
          });
          _getReport();
        },
        onError: (code, error) {
          _getReport();
        },
      );
    } else {
      _getReport();
    }
  }

  _getReport() {
    Map<String, dynamic> map = new HashMap();

    ///有报告的情况
    if (collectors.length > 0) {
      currentSerialNum = collectors[currentCollector].serialNum;
      map['serial_num'] = currentSerialNum;

      _getReportContent(map);
    } else {
      ///没报告，请求示例报告
      map['sample'] = genderType == 6 ? "male" : "female";
      HttpUtils.requestHttp(
        ApiConstant.reportSample,
        isNeedCache: true,
        method: HttpUtils.GET,
        onSuccess: (result) async {
          List l = result;
          reportSamples.clear();
          l.forEach((element) {
            var reportSampleModel = ReportSampleModel.fromJson(element);
            reportSamples.add(reportSampleModel);
            if ((genderType == 6 ? 'male' : 'female') ==
                reportSampleModel.sex) {
              sampleReportIndex = l.indexOf(element);
            }
          });
          _getReportContent(map);
          // setState(() {});
        },
        onError: (code, error) {},
      );
    }
  }

  _getReportContent(map) {
    _getReportSummary(map);
    _getReportJingXuan(map);
  }

  _getReportJingXuan(Map map) {
    HttpUtils.requestHttp(
      ApiConstant.reportJinxuan,
      parameters: map,
      isNeedCache: true,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        List l = result;
        jinxuanDatas.clear();
        l.forEach((element) {
          jinxuanDatas.add(JinxuanModel.fromJson(element));
        });
        setState(() {});
      },
      onError: (code, error) {},
    );
  }

  _getReportSummary(Map map) {
    HttpUtils.requestHttp(
      ApiConstant.reportSummary,
      parameters: map,
      method: HttpUtils.GET,
      isNeedCache: true,
      onSuccess: (result) async {
        List l = result;
        categories.clear();
        l.forEach((element) {
          var reportSummaryModel = ReportSummaryModel.fromJson(element);
          categories.add(reportSummaryModel);
          if (null != scope && scope == reportSummaryModel.code) {
            scope = null;
            NavigatorUtil.push(
                context,
                ReportLevel1Page(
                  type: genderType == 6 ? "male" : "female",
                  id: reportSummaryModel.code,
                  summaryModel: reportSummaryModel,
                  serialNum: collectors.length > 0
                      ? collectors[currentCollector].serialNum
                      : null,
                ));
          }
        });
        setState(() {});
      },
      onError: (code, error) {},
    );
  }
}
