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
    _tabController.dispose();
    super.dispose();
  }

  _getDatas() {
    Map<String, dynamic> map = new HashMap();

    map['id'] = widget.id;
    // map['id'] = "yongyaozhidao";
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
          if (null != element["group"]) {
            tabs.add(ReportListModel.fromJson(element));
          } else {
            list.add(ReportDataList.fromJson(element));
          }
        });
        if (tabs.length > 0) {
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
              _buildSliverAppBar(),
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

    return Padding(
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
          child: ReportLevel1BodyPage(),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
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
        // Row(
        //   children: reportDesModel.items.map((e) => _titletip(e)).toList(),
        // )
      ],
    );
  }

  Widget _titletip(Items item) {
    return Container(
      margin: EdgeInsets.only(top: 16, right: 10),
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
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
            "${item.title}  ${item.number}",
            style: TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
    );
  }
}
