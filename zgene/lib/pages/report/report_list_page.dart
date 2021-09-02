import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/base_widget.dart';

class ReportListPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() => _ReportListPageState();
}

class _ReportListPageState extends BaseWidgetState<ReportListPage> {
  final data = <Color>[
    Colors.purple[50],
    Colors.purple[100],
    Colors.purple[200],
    Colors.purple[300],
    Colors.purple[400],
    Colors.purple[500],
    Colors.purple[600],
    Colors.purple[700],
    Colors.purple[800],
    Colors.purple[900],
    Colors.purple[50],
    Colors.purple[100],
    Colors.purple[200],
    Colors.purple[300],
    Colors.purple[400],
    Colors.purple[500],
    Colors.purple[600],
    Colors.purple[700],
    Colors.purple[800],
    Colors.purple[900],
  ];

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();

    showBaseHead = false;
    showHead = false;
    // pageWidgetTitle = "运动健康";
    isListPage = true;
    backColor = Colors.red;
    // backImgPath = "assets/images/home/bg_home.png";
  }

  Widget viewPageBody(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: <Widget>[
            _buildSliverAppBar(),
            _buildPersistentHeader(),
            _buildSliverList()
          ],
        ),
        Positioned(
            left: 15,
            right: 15,
            bottom: 30,
            child: Column(
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27)),
                  minWidth: double.infinity,
                  disabledColor: Colors.white,
                  color: ColorConstant.TextMainColor,
                  onPressed: () {},
                  child: Text("立即购买",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                )
              ],
            ))
      ],
    );
  }

  Widget _buildPersistentHeader() => SliverPersistentHeader(
      pinned: true,
      delegate: _SliverDelegate(
        minHeight: 44.0,
        maxHeight: 44.0,
        child: Container(
            color: Colors.white.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 64),
                  child: Text(
                    "项目",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.TextMainBlack),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 64),
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
      ));

  Widget _buildSliverList() => SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 12, 0, 100),
            itemBuilder: (BuildContext context, int index) {
              return _buildSliverItem(index);
            },
          ),
        ),
      );

  Widget _buildSliverItem(index) {
    return Opacity(
      opacity: index < 3 ? 1 : 0.4,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "锻炼对体重指数效果",
                style: TextStyle(
                    color: ColorConstant.TextMainBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
            Image.asset(
              "assets/images/report/img_qiang.png",
              width: 22,
              height: 22,
            ),
            Padding(
              padding: EdgeInsets.only(left: 6, right: 28),
              child: Text(
                "弱",
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
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 277.0,
      leading: _buildLeading(),
      title: Text(
        '运动健康',
        style: TextStyle(
            fontSize: 18,
            color: ColorConstant.TextMainBlack,
            fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      foregroundColor: Colors.transparent,
      pinned: true,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        //伸展处布局
        titlePadding: EdgeInsets.only(left: 55, bottom: 15),
        //标题边距
        collapseMode: CollapseMode.parallax,
        //视差效果
        background: Container(
          color: Colors.blue,
          padding: EdgeInsets.fromLTRB(16, 109, 16, 0),
          child: Image.asset(
            "assets/images/report/banner_yundong.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() => GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            margin: EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/icon_base_backArrow.png',
              height: 40,
              width: 40,
            )),
      );

  String colorString(Color color) =>
      "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
}

class _SliverDelegate extends SliverPersistentHeaderDelegate {
  _SliverDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight; //最小高度
  final double maxHeight; //最大高度
  final Widget child; //孩子

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override //是否需要重建
  bool shouldRebuild(_SliverDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
