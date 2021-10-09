import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/pages/home/content_tab_item.dart';

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
        return ContentTabItem(
          index: _tabController.index,
        );
      });
}
