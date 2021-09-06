import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/archive_des_model.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/models/report_des_model.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

class ReportListPage extends BaseWidget {
  var _archives;

  ReportListPage(bean) {
    _archives = bean;
  }

  @override
  BaseWidgetState<BaseWidget> getState() => _ReportListPageState();
}

class _ReportListPageState extends BaseWidgetState<ReportListPage> {
  var canFixedHeadShow = false;
  ReportDesModel reportDesModel;
  List list = [];

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();

    showBaseHead = false;
    showHead = true;
    pageWidgetTitle = widget._archives.title;
    isListPage = true;
    // backColor = Colors.red;
    backImgPath = "assets/images/mine/img_bg_my.png";

    listeningController.addListener(() {
      if (listeningController.position.pixels.toInt() > 170 &&
          !canFixedHeadShow) {
        setState(() {
          canFixedHeadShow = true;
        });
      }
      if (listeningController.position.pixels.toInt() <= 170 &&
          canFixedHeadShow) {
        setState(() {
          canFixedHeadShow = false;
        });
      }
    });
    var json = jsonDecode(widget._archives.description);
    reportDesModel = ReportDesModel.fromJson(json);

    ArchiveGetHttp(widget._archives.id, (result) {
      ArchiveDesModel model = ArchiveDesModel.fromJson(result);
      list.clear();
      setState(() {
        list = model.addon.archives;
      });
    });
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
              _buildPersistentHeader(170),
              _buildSliverList(),
            ],
          ),
        ),
        _buildfixedHeader(),
        Positioned(left: 15, right: 15, bottom: 30, child: _buy)
      ],
    );
  }

  Widget get _buy {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            "以上仅为示例报告，购买以解锁我的专属报告",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorConstant.TextMainBlack),
          ),
        ),
        MaterialButton(
          height: 48,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
          minWidth: double.infinity,
          disabledColor: Colors.white,
          color: ColorConstant.TextMainColor,
          onPressed: () {
            UiUitls.showToast("立即购买");
          },
          child: Text("立即购买",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
        )
      ],
    );
  }

  Widget _buildfixedHeader() => Opacity(
        opacity: canFixedHeadShow ? 1 : 0,
        child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25 * (1 - trans / 255)),
                topRight: Radius.circular(25 * (1 - trans / 255)),
              ),
            ),
            child: Row(
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
            )),
      );

  Widget _buildPersistentHeader(double marginHeight) => Container(
      height: 88,
      margin: EdgeInsets.only(top: marginHeight),
      decoration: BoxDecoration(
        color: Color.fromARGB(trans < 150 ? 150 : trans, 255, 255, 255),
        // color: Colors.white,
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
      child: Row(
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
      ));

  Widget _buildSliverList() => Container(
        margin: EdgeInsets.only(top: 220),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0, 12, 0, 140),
          itemBuilder: (BuildContext context, int index) {
            return _buildSliverItem(context, list[index], index);
          },
        ),
      );

  Widget _buildSliverItem(context, archive, index) {
    var json = jsonDecode(archive.description);
    ReportDesModel model = ReportDesModel.fromJson(json);

    return GestureDetector(
      onTap: () {
        CommonUtils.toUrl(
            context: context, type: archive.linkType, url: archive.linkUrl);
      },
      child: Opacity(
        opacity: index < 3 ? 1 : 0.4,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  archive.title,
                  style: TextStyle(
                      color: ColorConstant.TextMainBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ),
              if (null != model &&
                  null != model.items &&
                  model.items.length > 0)
                Image.asset(
                  _getAssetIcon(model.items[0].color),
                  width: 22,
                  height: 22,
                ),
              if (null != model &&
                  null != model.items &&
                  model.items.length > 0)
                Padding(
                  padding: EdgeInsets.only(left: 6, right: 28),
                  child: Text(
                    model.items[0].title,
                    style: TextStyle(
                        color: ColorConstant.Text_8E9AB,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
              Image.asset(
                "assets/images/mine/icon_my_name_right.png",
                width: 22,
                height: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAssetIcon(String color) {
    if ("green" == color) {
      return "assets/images/report/img_zhong.png";
    }
    if ("blue" == color) {
      return "assets/images/report/img_qiang.png";
    }
    if ("red" == color) {
      return "assets/images/report/img_luo.png";
    }
  }

  Widget _buildSliverAppBar() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 168,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(
                CommonUtils.splicingUrl(widget._archives.imageUrl)),
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
          widget._archives.title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
        ),
        Text(
          widget._archives.keywords,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
        ),
        if (null != reportDesModel.items)
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
              gradient: _getTipColor(item.color),
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

  _getTipColor(String color) {
    if ("green" == color) {
      return LinearGradient(colors: [
        Color(0xFF47FEDB),
        Color(0xFF23CFAF),
      ]);
    }
    if ("blue" == color) {
      return LinearGradient(colors: [
        Color(0xFF5EECFD),
        Color(0xFF248DFA),
      ]);
    }
    if ("red" == color) {
      return LinearGradient(colors: [
        Color(0xFFFE8B8C),
        Color(0xFFFE4343),
      ]);
    }
  }
}
