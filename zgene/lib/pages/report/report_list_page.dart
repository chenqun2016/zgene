import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/ui_uitls.dart';

class ReportListPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() => _ReportListPageState();
}

class _ReportListPageState extends BaseWidgetState<ReportListPage> {
  final data = <int>[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();

    showBaseHead = false;
    showHead = true;
    pageWidgetTitle = "运动健康";
    isListPage = true;
    // backColor = Colors.red;
    backImgPath = "assets/images/mine/img_bg_my.png";
  }

  Widget viewPageBody(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          physics: BouncingScrollPhysics(),
          controller: listeningController,
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
        minHeight: 50.0,
        maxHeight: 50.0,
        child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(trans, 255, 255, 255),
              // color: Colors.white,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
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
      ));

  Widget _buildSliverList() => SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(20),
            //   topRight: Radius.circular(20),
            // ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 12, 0, 140),
            itemBuilder: (BuildContext context, int index) {
              return _buildSliverItem(index);
            },
          ),
        ),
      );

  Widget _buildSliverItem(index) {
    return GestureDetector(
      onTap: () {
        UiUitls.showToast("index==$index");
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
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 148,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //   image: AssetImage("assets/images/report/banner_yundong.png"),
            //   fit: BoxFit.fill,
            // )),
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Stack(
              children: [
                ClipRect(
                  child: Image.asset(
                    "assets/images/report/banner_yundong.png",
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    height: 148,
                  ),
                ),
                _titleContent,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _titleContent {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 22, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "运动健身",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
          ),
          Text(
            "共12项",
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
          ),
          Row(
            children: [
              Container(
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
                        gradient: LinearGradient(colors: [
                          Color(0xFF47FEDB),
                          Color(0xFF23CFAF),
                        ]),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    Text(
                      "强  04",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
              Container(
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
                        gradient: LinearGradient(colors: [
                          Color(0xFF5EECFD),
                          Color(0xFF248DFA),
                        ]),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    Text(
                      "中  07",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
              Container(
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
                        gradient: LinearGradient(colors: [
                          Color(0xFFFE8B8C),
                          Color(0xFFFE4343),
                        ]),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    Text(
                      "弱  01",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
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
