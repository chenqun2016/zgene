import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/home/video_page.dart';
import 'package:zgene/util/common_utils.dart';

class ContentListNav extends StatefulWidget {
  const ContentListNav({Key key}) : super(key: key);

  @override
  _ContentListNavState createState() => _ContentListNavState();
}

class _ContentListNavState extends State<ContentListNav>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final tabs = ['精选', '基因研究院', '用户测评'];
  TabController _tabController;

  List contentList = [1, 2, 3, 4, 5, 6, 7];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 15, right: 15),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildTabBar(), _buildTableBarView()],
      ),
    );
  }

  Widget _buildTabBar() => TabBar(
        onTap: (tab) => print(tab),
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 15),
        isScrollable: true,
        controller: _tabController,
        labelColor: ColorConstant.TextMainColor,
        unselectedLabelColor: ColorConstant.Text_5E6F88,
        indicatorWeight: 3,
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        indicatorColor: ColorConstant.TextMainColor,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
      );

  Widget _buildTableBarView() => AnimatedBuilder(
      animation: _tabController.animation,
      builder: (ctx, child) {
        return _itemList(_tabController.index);
      });

  Widget _itemList(int indexOf) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 15),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: contentList.length,
        itemBuilder: (BuildContext context, int index) =>
            _getItemWidget(index, indexOf),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        staggeredTileBuilder: (int index) => index % 3 == indexOf
            ? StaggeredTile.extent(2, 185)
            : StaggeredTile.extent(1, 200),
      ),
    );
  }

  Widget _getItemWidget(int index, int indexOf) {
    return index % 3 == indexOf ? _getItemWidgetType1() : _getItemWidgetType2();
  }

  Widget _getItemWidgetType2() {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstant.bg_F7F7F8,
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              NavigatorUtil.push(
                  context,
                  VideoPage(
                      linkUrl:
                          "https://zgene.divms.com/public/statics/video/z-gene.mp4"));
            },
            child: PhysicalModel(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    topLeft: Radius.circular(14)),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  "assets/images/home/test_img_home.png",
                  height: 112,
                  width: double.infinity,
                  fit: BoxFit.fill,
                )
                // new CachedNetworkImage(
                //   width: double.infinity,
                //   // 设置根据宽度计算高度
                //   height: 112,
                //   // 图片地址
                //   imageUrl: CommonUtils.splicingUrl(
                //       "/uploads/2021/0914/e741f1851b6a4a61.png"),
                //   // 填充方式为cover
                //   fit: BoxFit.fill,
                // ),
                ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Text(
              "00后都开始脱发了？到底发生了什么？",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 8, bottom: 14),
            alignment: Alignment.bottomLeft,
            child: Text(
              "Z基因App",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ColorConstant.Text_5E6F88,
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _getItemWidgetType1() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 9),
              padding: EdgeInsets.fromLTRB(7, 1, 7, 3),
              decoration: BoxDecoration(
                color: ColorConstant.Text_5FC88F,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Text(
                "用户测评",
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.WhiteColor,
                ),
              ),
            ),
            Text(
              "美妆黑科技-看看这位博主怎么说？",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: GestureDetector(
            onTap: () {
              NavigatorUtil.push(
                  context,
                  VideoPage(
                      linkUrl:
                          "https://zgene.divms.com/public/statics/video/z-gene.mp4"));
            },
            child: PhysicalModel(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              child: new CachedNetworkImage(
                width: double.infinity,
                // 设置根据宽度计算高度
                height: 152,
                // 图片地址
                imageUrl: CommonUtils.splicingUrl(
                    "/uploads/2021/0914/e741f1851b6a4a61.png"),
                // 填充方式为cover
                fit: BoxFit.fill,
              ),
            ),
          ),
        )
      ],
    );
  }
}
