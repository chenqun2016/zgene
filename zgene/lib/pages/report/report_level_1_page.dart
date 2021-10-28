import 'dart:collection';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/report_des_model.dart';
import 'package:zgene/models/report_list_model.dart';
import 'package:zgene/models/report_summary_model.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/my_inherited_widget.dart';

import 'report_level_1_body_page.dart';

///报告列表页
class ReportLevel1Page extends BaseWidget {
  final String id;
  String serialNum;
  final ReportSummaryModel summaryModel;
  final String type;
  ReportLevel1Page(
      {Key key, this.id, this.serialNum, this.summaryModel, this.type})
      : super(key: key);

  @override
  BaseWidgetState<ReportLevel1Page> getState() => _ReportLevel1PageState();
}

class _ReportLevel1PageState extends BaseWidgetState<ReportLevel1Page>
    with SingleTickerProviderStateMixin {
  var canFixedHeadShow = false;

  var persistentHeaderTopMargin = 164.0;
  TabController _tabController;

  var list = [];
  var tabs = [];

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showBaseHead = false;
    showHead = true;
    isListPage = true;
    // backColor = Colors.red;
    backImgPath = "assets/images/mine/img_bg_my.png";
    pageWidgetTitle = widget.summaryModel.name;
    listeningController.addListener(() {
      if (listeningController.position.pixels.toInt() >=
              persistentHeaderTopMargin &&
          !canFixedHeadShow) {
        setState(() {
          canFixedHeadShow = true;
        });
      }
      if (listeningController.position.pixels.toInt() <
              persistentHeaderTopMargin &&
          canFixedHeadShow) {
        setState(() {
          canFixedHeadShow = false;
        });
      }
    });

    _getDatas();
  }

  @override
  void dispose() {
    if (null != _tabController) _tabController.dispose();
    super.dispose();
  }

  int risk_count = 0;
  int middle_count = 0;
  List<Items> tags = [];
  _getDatas() {
    Map<String, dynamic> map = new HashMap();

    ///接口类型
    map['id'] = widget.id;
    // map['id'] = "yongyaozhidao";
    ///有采集器编号，请求个人采集器相关报告，否则请求示例报告
    if (widget.serialNum != null) {
      map['serial_num'] = widget.serialNum;
    } else {
      map['sample'] = widget.type;
    }

    HttpUtils.requestHttp(
      ApiConstant.reportList,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        List l = result;
        tabs.clear();
        list.clear();
        l.forEach((element) {
          ///两种类型的数据格式
          ///有group字段的代表有  tab
          ///否则 没有 tab
          if (null != element["group"]) {
            var reportListModel = ReportListModel.fromJson(element);
            if (element['data_list'] != null) {
              element['data_list'].forEach((v) {
                var reportDataList = new ReportDataList.fromJson(v);
                reportListModel.dataList.add(reportDataList);
                _caculate(reportDataList);
              });
            }
            tabs.add(reportListModel);
          } else {
            var reportDataList = ReportDataList.fromJson(element);
            list.add(reportDataList);
            _caculate(reportDataList);
          }
        });

        if (tabs.length > 0) {
          ///初始化 tab
          _tabController = TabController(vsync: this, length: tabs.length);
          _tabController.addListener(() {
            if (_tabController.animation?.value == _tabController.index) {
              setState(() {});
              list = tabs[_tabController.index].dataList;
              if (listeningController?.hasClients &&
                  listeningController.offset > persistentHeaderTopMargin)
                listeningController?.jumpTo(persistentHeaderTopMargin + 4);
            }
          });
          list = tabs[0].dataList;
        }
        _initTags();

        setState(() {});
      },
      onError: (code, error) {},
    );
  }

  ///计算title中标签 强，中，弱 的个数
  void _caculate(ReportDataList reportDataList) {
    if (null != reportDataList.tag) {
      if (int.parse(reportDataList.tag) >= 1) {
        ///计算需关注的个数
        risk_count += 1;
      } else if (int.parse(reportDataList.tag) == 0) {
        ///计算不需关注的个数
        middle_count += 1;
      }
    } else if (null != reportDataList.conclusion) {
      if ("高风险" == reportDataList.conclusion) {
        risk_count += 1;
      } else if ("一般风险" == reportDataList.conclusion) {
        middle_count += 1;
      }
    }
  }

  ///根据 _caculate()方法计算的数据，设置不同类型的标签数据
  ///用药指导是2个标签，其他都是3个
  void _initTags() {
    List tagStrs = [];
    switch (widget.id) {
      case "yongyaozhidao": //用药指导
        ///用药指导：设置标签数据
        tagStrs = ["正常", "需关注"];
        break;
      case "jibingshaicha": //疾病筛查 肿瘤报告
        tagStrs = ["低", "中", "高"];
        break;
      case "pifuguanli": //皮肤管理
      case "tizhitedian": //体质特点
        tagStrs = ["一般", "正常", "较高"];
        break;
      case "xinlirenzhi": //心理认知
        tagStrs = ["高", "中", "低"];
        break;
      case "daixienengli": //代谢能力
      case "jiankangfengxian": //健康风险
      case "yingyangxuqiu": //营养需求
      case "yundongjianshen": //运动健身
      default:
        tagStrs = ["强", "中", "弱"];
        break;
    }
    if (tagStrs.length == 2) {
      tags.add(Items(
          color: "green",
          number: (widget.summaryModel.count - risk_count),
          title: tagStrs[0]));
      tags.add(Items(color: "red", number: risk_count, title: tagStrs[1]));
    } else {
      tags.add(Items(
          color: "green",
          number: (widget.summaryModel.count - risk_count - middle_count),
          title: tagStrs[0]));
      tags.add(Items(color: "blue", number: (middle_count), title: tagStrs[1]));
      tags.add(Items(color: "red", number: risk_count, title: tagStrs[2]));
    }
  }

  Widget viewPageBody(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: listeningController,
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              _buildSliverTitle(),
              _buildPersistentHeader(),
              _buildSliverList(),
            ],
          ),
        ),
        if (canFixedHeadShow) _buildfixedHeader(),
      ],
    );
  }

  Widget _buildfixedHeader() => Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
          topRight: Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
        ),
      ),
      child: _getTitleView());

  Widget _buildPersistentHeader() => Container(
      height: 88,
      margin: EdgeInsets.only(top: persistentHeaderTopMargin),
      decoration: BoxDecoration(
        // color: Color.fromARGB(trans < 150 ? 150 : trans, 255, 255, 255),
        color: Colors.white60,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.only(
          // topLeft: Radius.circular(25 * (1 - trans / 255)),
          // topRight: Radius.circular(25 * (1 - trans / 255)),
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: PhysicalModel(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.only(
          // topLeft: Radius.circular(25 * (1 - trans / 255)),
          // topRight: Radius.circular(25 * (1 - trans / 255)),
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), //可以看源码
          child: Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            child: _getTitleView(),
          ),
        ),
      ));

  Widget _getTitleView() {
    return tabs.length > 0 ? _titleTabView() : _titleView();
  }

  Widget _titleTabView() {
    return TabBar(
      onTap: (tab) {},
      labelPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      indicatorPadding: EdgeInsets.fromLTRB(10, 0, 10, 6),
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      unselectedLabelStyle:
          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      isScrollable: true,
      controller: _tabController,
      labelColor: ColorConstant.TextMainColor,
      unselectedLabelColor: ColorConstant.Text_5E6F88,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: ColorConstant.TextMainColor,
      tabs: tabs.map((e) => Tab(text: e.group)).toList(),
    );
  }

  Widget _titleView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 64, top: 14),
          child: Text(
            "项目",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          height: 12,
          width: 1,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.only(right: 64, top: 14),
          child: Text(
            "结果",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack),
          ),
        )
      ],
    );
  }

  Widget _buildSliverList() {
    double bottom;
    var bottomPadding =
        (48 * list.length) + 85 + (55.h + MediaQuery.of(context).padding.top);
    if (bottomPadding < MediaQuery.of(context).size.height) {
      bottom = MediaQuery.of(context).size.height - bottomPadding;
    } else {
      bottom = 0;
    }

    return tags.length == 0
        ? Text("")
        : Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Container(
              margin: EdgeInsets.only(top: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: MyInheritedWidget(
                data: list,
                child: ReportLevel1BodyPage(
                  id: widget.id,
                  serialNum: widget.serialNum,
                  type: widget.type,
                  tags: tags,
                ),
              ),
            ),
          );
  }

  Widget _buildSliverTitle() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 168,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(UiUitls.getReportListIcon(widget.id)),
            fit: BoxFit.fill,
          )),
          padding: EdgeInsets.fromLTRB(30, 22, 0, 0),
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Stack(
            children: [
              // ClipRect(
              //   child: Image.asset(
              //     "assets/images/report/banner_yundong.png",
              //     fit: BoxFit.cover,
              //     alignment: Alignment.topCenter,
              //     width: double.infinity,
              //     height: 148,
              //   ),
              // ),
              _titleContent,
            ],
          ),
        ),
      ],
    );
  }

  Widget get _titleContent {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.summaryModel.name,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
        ),
        Text(
          "共${widget.summaryModel.count}项",
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
        ),
        Row(
          children: tags.map((e) => _titletip(e)).toList(),
        )
      ],
    );
  }

  Widget _titletip(Items item) {
    return Container(
      margin: EdgeInsets.only(top: 16, right: 10),
      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: Row(
        children: [
          Container(
            height: 12,
            width: 12,
            margin: EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              gradient: UiUitls.getTipColor(item.color),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
          Text(
            "${item.title} ${item.number}",
            style: TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
    );
  }
}
