import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/archive_des_model.dart';
import 'package:zgene/models/report_des_model.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/my_inherited_widget.dart';

import 'report_level_1_body_page.dart';

class ReportLevel1Page extends BaseWidget {
  final int id;

  ReportLevel1Page({Key key, this.id}) : super(key: key);

  @override
  BaseWidgetState<ReportLevel1Page> getState() => _ReportLevel1PageState();
}

class _ReportLevel1PageState extends BaseWidgetState<ReportLevel1Page>
    with SingleTickerProviderStateMixin {
  var canFixedHeadShow = false;
  ReportDesModel reportDesModel;
  List list = [];
  Archive _archive;
  int id;
  var persistentHeaderTopMargin = 164.0;
  TabController _tabController;
  final tabs = [
    '心血管',
    '抗肿瘤',
    '风湿免疫',
    '心血管',
    '抗肿瘤',
    '风湿免疫',
    '心血管',
    '抗肿瘤',
    '风湿免疫'
  ];

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    id = widget.id;

    showBaseHead = false;
    showHead = true;
    isListPage = true;
    // backColor = Colors.red;
    backImgPath = "assets/images/mine/img_bg_my.png";

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

    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(() {
      if (_tabController.animation?.value == _tabController.index) {
        setState(() {
          print("_tabController.listener");
          list = list.sublist(1, list.length);
        });
        if (listeningController?.hasClients &&
            listeningController.offset > persistentHeaderTopMargin)
          listeningController?.jumpTo(persistentHeaderTopMargin + 4);
      }
    });
  }

  bool hasDatas = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              _buildSliverAppBar(),
              _buildPersistentHeader(),
              _buildSliverList(),
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
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
                topRight:
                    Radius.circular(25 * (1 - trans / APPBAR_SCORLL_OFFSET)),
              ),
            ),
            child: _getTitleView()),
      );

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
    return tabs.length > 1 ? _titleTabView() : _titleView();
  }

  Widget _titleTabView() {
    return TabBar(
      onTap: (tab) => print(tab),
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
      tabs: tabs.map((e) => Tab(text: e)).toList(),
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

  Widget _buildSliverList() => Container(
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
      );

  Widget _buildSliverAppBar() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 168,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(CommonUtils.splicingUrl(_archive.imageUrl)),
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
          _archive.title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
        ),
        Text(
          _archive.keywords,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
        ),
        if (null != reportDesModel && null != reportDesModel.items)
          Row(
            children: reportDesModel.items.map((e) => _titletip(e)).toList(),
          )
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
