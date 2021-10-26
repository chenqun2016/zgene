import 'dart:collection';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/report_list_detail_model.dart';
import 'package:zgene/pages/report/item/my_report_result.dart';
import 'package:zgene/pages/report/item/my_report_sciencedetail.dart';
import 'package:zgene/util/base_widget.dart';

class ReportLevel2Page extends BaseWidget {
  final String id;
  final String itemid;
  String serialNum;
  final String type;

  ReportLevel2Page({Key key, this.id, this.itemid, this.serialNum, this.type})
      : super(key: key);

  @override
  BaseWidgetState<ReportLevel2Page> getState() => _ReportLevel2PageState();
}

class _ReportLevel2PageState extends BaseWidgetState<ReportLevel2Page>
    with SingleTickerProviderStateMixin {
  var canFixedHeadShow = false;
  var persistentHeaderTopMargin = 148.0;
  final tabs = ['检测结果', '科学细节'];
  //顶部两种title， 0：图片类型，1：进度条类型
  var topType = 0;
  String topResult = "结果显示您携带可能导致叶酸吸收能力降低的基因多态性，叶酸吸收能力较弱";
  var topTextStype = TextStyle(
      color: ColorConstant.Text_5E6F88,
      fontWeight: FontWeight.w600,
      fontSize: 16);

  TabController _tabController;
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
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

    _getDatas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _getDatas() {
    Map<String, dynamic> map = new HashMap();

    map['itemid'] = widget.itemid;
    map['id'] = widget.id;
    if (widget.serialNum != null) {
      map['serial_num'] = widget.serialNum;
    } else {
      map['sample'] = widget.type;
    }

    HttpUtils.requestHttp(
      ApiConstant.reportDetail,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        var reportData = ReportListDetailModel.fromJson(result);
        pageWidgetTitle = reportData.chname;
        setState(() {});
      },
      onError: (code, error) {},
    );
  }

  Widget viewPageBody(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: listeningController,
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              //TODO 两种 title
              if (topType == 0) _buildTitle(),
              if (topType == 1) _buildTitle2(),
              _buildPersistentHeaderList(),
            ],
          ),
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

  Widget _buildPersistentHeaderList() {
    if (topType == 0) return _buildList();
    return LayoutBuilder(builder: (context, size) {
      final painter = TextPainter(
        text: TextSpan(text: topResult, style: topTextStype),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      );
      painter.layout(maxWidth: size.maxWidth);
      if (painter.didExceedMaxLines) persistentHeaderTopMargin = 170;
      return _buildList();
    });
  }

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

  Widget get _buildSliverList => Container(
        color: Colors.transparent,
        child: _tabController.index == 0
            ? _getMyReportResult
            : _getMyReportScienceDetail,
      );

  Widget get _getMyReportResult => MyReportResult();
  Widget get _getMyReportScienceDetail => MyReportScienceDetail();

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      height: 168,
      decoration: BoxDecoration(
          image: DecorationImage(
        // image: NetworkImage(CommonUtils.splicingUrl(_archive.imageUrl)),
        //TODO 切换图片
        // image: AssetImage("assets/images/report/img_jieguo_1.png"),
        image: AssetImage("assets/images/report/img_jieguo_0.png"),
        fit: BoxFit.fill,
      )),
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: _titleContent,
    );
  }

  Widget get _titleContent {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "一般风险",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 32),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            "您的精神分裂症患病风险为 \n 一般风险",
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
    return Container(
      width: double.infinity,
      height: 168,
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
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: 20,
            child: Stack(
              children: [
                Positioned(
                  top: 4,
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
                    top: 4,
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
                    top: 4,
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
                            color: ColorConstant.bg_42F5D3,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        );
                      },
                    )),
                Positioned(
                    left: width * 50 / 100 - 7,
                    top: 0,
                    child: Container(
                        height: 14,
                        width: 14,
                        margin: EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorConstant.bg_017AF6,
                            width: 4,
                          ),
                          color: ColorConstant.WhiteColor,
                        )))
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
                      color: ColorConstant.bg_42F5D3,
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
            padding: EdgeInsets.only(left: 24, right: 24),
            alignment: Alignment.topCenter,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFF007AF7).withAlpha(40),
              Color(0xFF007AF7).withAlpha(0),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
            child: Text(
              topResult,
              textAlign: TextAlign.center,
              style: topTextStype,
            ),
          ))
        ],
      ),
    );
  }
}
