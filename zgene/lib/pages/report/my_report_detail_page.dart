import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/archive_des_model.dart';
import 'package:zgene/models/report_des_model.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/pages/report/item/my_report_result.dart';
import 'package:zgene/pages/report/item/my_report_sciencedetail.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';

class MyReportDetailPage extends BaseWidget {
  final int id;

  MyReportDetailPage({Key key, this.id}) : super(key: key);

  @override
  BaseWidgetState<MyReportDetailPage> getState() => _MyReportDetailPageState();
}

class _MyReportDetailPageState extends BaseWidgetState<MyReportDetailPage>
    with SingleTickerProviderStateMixin {
  var canFixedHeadShow = false;
  ReportDesModel reportDesModel;
  List list = [];
  Archive _archive;
  int id;
  var persistentHeaderTopMargin = 148.0;
  final tabs = ['检测结果', '科学细节'];
  TabController _tabController;
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    id = widget.id;
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
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool hasDatas = false;

  _getDatas() {
    String arg = ModalRoute.of(context).settings.arguments;
    if (null != arg) {
      id = int.parse(arg);
    }
    ArchiveGetHttp(id, (result) {
      ArchiveDesModel model = ArchiveDesModel.fromJson(result);
      list.clear();
      setState(() {
        list = model.addon.archives;
        _archive = model.archive;
        try {
          pageWidgetTitle = _archive.title;

          log("hahaha==" + _archive.description);
          if (null != _archive.description && _archive.description.isNotEmpty) {
            var json = jsonDecode(_archive.description);
            reportDesModel = ReportDesModel.fromJson(json);
          }
        } catch (e) {
          print("exception==" + e.toString());
        }
      });
    });
  }

  Widget viewPageBody(BuildContext context) {
    if (!hasDatas) {
      hasDatas = true;
      _getDatas();
    }
    if (null == _archive) {
      return Text("");
    }
    return Stack(
      children: [
        SingleChildScrollView(
          controller: listeningController,
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              _buildTitle(),
              _buildPersistentHeaderList(),
            ],
          ),
        ),
        _buildfixedHeader(),
      ],
    );
  }

  Widget _buildfixedHeader() => Opacity(
        opacity: canFixedHeadShow ? 1 : 0,
        child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25 * (1 - trans / 255)),
                topRight: Radius.circular(25 * (1 - trans / 255)),
              ),
            ),
            child: _buildTabBar),
      );

  Widget _buildPersistentHeaderList() => Container(
      margin:
          EdgeInsets.only(top: persistentHeaderTopMargin, left: 2, right: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25 * (1 - trans / 255)),
          topRight: Radius.circular(25 * (1 - trans / 255)),
        ),
      ),
      child: PhysicalModel(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25 * (1 - trans / 255)),
          topRight: Radius.circular(25 * (1 - trans / 255)),
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
            indicatorPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
        image: NetworkImage(CommonUtils.splicingUrl(_archive.imageUrl)),
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
}
