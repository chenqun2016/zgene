import 'dart:collection';
import 'dart:ui';

import 'package:base/widget/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/report_list_detail_model.dart';
import 'package:zgene/pages/report/item/report_result.dart';
import 'package:zgene/pages/report/item/report_sciencedetail.dart';
import 'package:zgene/pages/tabs/report_page.dart';
import 'package:zgene/widget/progress_page.dart';
import 'package:zgene/widget/star_shape_border.dart';

///报告详情页
class ReportLevel2Page extends StatefulWidget {
  ReportLevel2Page({Key key}) : super(key: key);

  @override
  BaseWidgetState<ReportLevel2Page> createState() => _ReportLevel2PageState();
}

class _ReportLevel2PageState extends BaseWidgetState<ReportLevel2Page>
    with SingleTickerProviderStateMixin {
  var canFixedHeadShow = false;
  var persistentHeaderTopMargin = 148.0;
  var tabs = ['检测结果', '科学细节'];
  //顶部两种title， 0：图片类型，1：进度条类型
  var topType = 0;
  var topTextStype = TextStyle(
      color: ColorConstant.Text_5E6F88,
      fontWeight: FontWeight.w600,
      fontSize: 16);

  TabController _tabController;
  ReportListDetailModel reportData;

  @override
  void customInitState() {
    super.customInitState();
    showBaseHead = false;
    showHead = true;
    isListPage = true;
    backImgPath = "assets/images/mine/img_bg_my.png";
    listeningController.addListener(() {
      if (listeningController.position.pixels.toInt() >
              persistentHeaderTopMargin &&
          !canFixedHeadShow) {
        setState(() {
          canFixedHeadShow = true;
        });
      }
      if (listeningController.position.pixels.toInt() <=
              persistentHeaderTopMargin &&
          canFixedHeadShow) {
        setState(() {
          canFixedHeadShow = false;
        });
      }
    });

    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(() {
      if (_tabController.animation?.value == _tabController.index) {
        setState(() {});
        if (listeningController?.hasClients &&
            listeningController.offset > persistentHeaderTopMargin)
          listeningController?.jumpTo(persistentHeaderTopMargin + 4);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String des = "";
  String title = "";
  AssetImage bg = AssetImage("assets/images/report/img_jieguo_0.png");
  _getDatas(BuildContext context) {
    Map<String, dynamic> map = new HashMap();
    var arguments = ModalRoute.of(context).settings.arguments;
    if (null != arguments && arguments is Map) {
      map['itemid'] = arguments['itemid'];
      map['id'] = arguments['scope'];
    }
    if (currentSerialNum != null) {
      map['serial_num'] = currentSerialNum;
    } else {
      map['sample'] = genderType == 6 ? "male" : "female";
    }

    HttpUtils.requestHttp(
      ApiConstant.reportDetail,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        reportData = ReportListDetailModel.fromJson(result);
        pageWidgetTitle = reportData.chname;

        switch (map['id']) {
          case "jibingshaicha": //疾病筛查 肿瘤报告 TODO 未携带
            tabs = ['检测结果', '科学细节'];
            continue next;
          case "jiankangfengxian": //健康风险
            tabs = ['药物概述', '科学细节'];
            continue next;
          next:
          case "pifuguanli": //皮肤管理
            if (reportData.conclusion == "高风险") {
              bg = AssetImage("assets/images/report/img_jieguo_1.png");
            } else {
              bg = AssetImage("assets/images/report/img_jieguo_0.png");
            }
            title = reportData.conclusion;
            des = "您的${reportData.chname}患病风险为 \n ${reportData.conclusion}";
            break;
          case "yongyaozhidao": //用药指导
            ///药物报告
            tabs = ['药物概述', '科学细节'];
            if (null != reportData.tag) {
              if (int.parse(reportData.tag) >= 1) {
                bg = AssetImage("assets/images/report/img_jieguo_1.png");
                title = "需关注";
              } else {
                bg = AssetImage("assets/images/report/img_jieguo_0.png");
                title = "正常用药";
              }
              des = reportData.conclusion;
            }
            break;

          // case "daixienengli": //代谢能力
          // case "tizhitedian": //体质特点
          // case "xinlirenzhi": //心理认知
          // case "yingyangxuqiu": //营养需求
          // case "yundongjianshen": //运动健身
          default:
            tabs = ['结果概述', '科学细节'];
            topType = 1;
            des = reportData.explain;
            break;
        }
        setState(() {});
      },
      onError: (code, error) {},
    );
  }

  bool firstGetData = true;
  Widget customBuildBody(BuildContext context) {
    if (firstGetData) {
      firstGetData = false;
      _getDatas(context);
    }
    return reportData == null
        ? ProgressPage()
        : Stack(
            children: [
              SingleChildScrollView(
                controller: listeningController,
                physics: BouncingScrollPhysics(),
                child: LayoutBuilder(builder: (context, size) {
                  final painter = TextPainter(
                    text: TextSpan(text: des, style: topTextStype),
                    maxLines: 3,
                    textDirection: TextDirection.ltr,
                    locale: Localizations.maybeLocaleOf(context),
                  );
                  if (topType == 0)
                    painter.layout(maxWidth: size.maxWidth - 60);
                  else
                    painter.layout(maxWidth: size.maxWidth - 80);

                  if (topType == 0)
                    persistentHeaderTopMargin = 100 + painter.height;
                  else
                    persistentHeaderTopMargin = 125 + painter.height;

                  print("height== ${painter.height}");
                  print(
                      "persistentHeaderTopMargin== ${persistentHeaderTopMargin}");
                  return Stack(
                    children: [
                      // 两种 title
                      if (topType == 0) _buildTitle(),
                      if (topType == 1) _buildTitle2(),
                      _buildList(),
                    ],
                  );
                }),
              ),
              if (canFixedHeadShow) _buildfixedHeader(),
            ],
          );
  }

  Widget _buildfixedHeader() => Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
          topRight: Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
        ),
      ),
      child: _buildTabBar);

  Widget _buildList() => Container(
      margin:
          EdgeInsets.only(top: persistentHeaderTopMargin, left: 2, right: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
          topRight: Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
        ),
      ),
      child: PhysicalModel(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
          topRight: Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
          // topLeft: Radius.circular(25),
          // topRight: Radius.circular(25),
        ),
        color: Color(0xc3FFFFFF),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Column(
            children: [
              _buildTabBar,
              _buildSliverList,
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  "assets/images/report/logo_zgene_bottom.png",
                  height: 20,
                  width: 191,
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
        ),
      ));

  Widget get _buildTabBar => Stack(
        alignment: Alignment.topCenter,
        children: [
          TabBar(
            onTap: (tab) => print(tab),
            labelPadding: EdgeInsets.zero,
            padding: EdgeInsets.only(top: 10),
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            isScrollable: false,
            controller: _tabController,
            labelColor: ColorConstant.TextMainColor,
            unselectedLabelColor: ColorConstant.Text_5E6F88,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.fromLTRB(10, 0, 10, 6),
            indicatorColor: ColorConstant.TextMainColor,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
          Container(
            margin: EdgeInsets.only(top: 28),
            height: 12,
            width: 1,
            color: Colors.white,
          ),
        ],
      );

  Widget get _buildSliverList => reportData == null
      ? Container(
          height: 300,
        )
      : Container(
          color: Colors.transparent,
          child: _tabController.index == 0
              ? _getMyReportResult
              : _getMyReportScienceDetail,
        );

  ///检测结果
  Widget get _getMyReportResult => ReportResult(
        reportData: reportData,
        topType: topType,
      );

  ///科学细节
  Widget get _getMyReportScienceDetail =>
      ReportScienceDetail(reportData: reportData);

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      height: persistentHeaderTopMargin + 25,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: bg,
        fit: BoxFit.fill,
      )),
      padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: _titleContent,
    );
  }

  Widget get _titleContent {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 32),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            des,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 15),
          ),
        ),
      ],
    );
  }

  ///第二种 title
  Widget _buildTitle2() {
    var width = MediaQuery.of(context).size.width - 80;
    var tag = 0;
    try {
      tag = int.parse(reportData.tag);
    } catch (e) {
      print(e);
    }

    var progress;
    if (tag == -1) {
      progress = width * 83 / 100 - 16;
    } else if (tag == 0) {
      progress = width * 50 / 100 - 16;
    } else {
      progress = width * 17 / 100 - 16;
    }

    return Container(
      width: double.infinity,
      height: persistentHeaderTopMargin,
      decoration: BoxDecoration(
        color: Colors.white60,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: 45,
            child: Stack(
              children: [
                Positioned(
                  top: 26,
                  child: Container(
                    width: width * 2 / 3,
                    height: 10,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      color: ColorConstant.bg_FD7A7A,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 26,
                    right: 0,
                    child: Container(
                      width: width * 2 / 3,
                      height: 10,
                      padding: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        color: ColorConstant.bg_017AF6,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    )),
                Positioned(
                    top: 26,
                    right: 0,
                    child: LayoutBuilder(
                      builder: (_, zone) {
                        return Container(
                          width: width * 1 / 3,
                          height: 10,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            color: ColorConstant.bg_24D780,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        );
                      },
                    )),
                // Positioned(
                //     left: progress,
                //     top: 0,
                //     child: Container(
                //         height: 14,
                //         width: 14,
                //         margin: EdgeInsets.only(top: 2),
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           border: Border.all(
                //             color: tag == -1
                //                 ? ColorConstant.bg_24D780
                //                 : (tag == 0
                //                 ? ColorConstant.bg_017AF6
                //                 : ColorConstant.bg_FD7A7A),
                //             width: 4,
                //           ),
                //           color: ColorConstant.WhiteColor,
                //         ))),
                Positioned(
                    left: progress,
                    top: 0,
                    child: Column(
                      children: [
                        ClipPath(
                          clipper: ShapeBorderClipper(shape: StarShapeBorder()),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(6, 2, 6, 6),
                            constraints: BoxConstraints(
                              minWidth: 30,
                            ),
                            color: tag == -1
                                ? ColorConstant.bg_24D780
                                : (tag == 0
                                    ? ColorConstant.bg_017AF6
                                    : ColorConstant.bg_FD7A7A),
                            // decoration: BoxDecoration(
                            //   image: DecorationImage(
                            //     image: AssetImage(
                            //         "assets/images/report/icon_qipao.png"),
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            child: Text(
                              "我",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10),
                            ),
                          ),
                        ),
                        Container(
                            height: 14,
                            width: 14,
                            margin: EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: tag == -1
                                    ? ColorConstant.bg_24D780
                                    : (tag == 0
                                        ? ColorConstant.bg_017AF6
                                        : ColorConstant.bg_FD7A7A),
                                width: 4,
                              ),
                              color: ColorConstant.WhiteColor,
                            ))
                      ],
                    ))
              ],
            ),
          ),
          Divider(
            height: 0,
            color: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "有害",
                  style: TextStyle(
                      color: ColorConstant.bg_FD7A7A,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                Text(
                  "正常",
                  style: TextStyle(
                      color: ColorConstant.bg_017AF6,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                Text(
                  "有益",
                  style: TextStyle(
                      color: ColorConstant.bg_24D780,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 12, left: 20, right: 20),
            color: ColorConstant.Text_B2BAC6.withAlpha(32),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.topCenter,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFF007AF7).withAlpha(40),
              Color(0xFF007AF7).withAlpha(0),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
            child: Text(
              reportData.explain,
              textAlign: TextAlign.center,
              style: topTextStype,
            ),
          ))
        ],
      ),
    );
  }
}
