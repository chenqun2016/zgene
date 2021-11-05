import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/category_model.dart';
import 'package:zgene/pages/home/content_tab_item.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/widget/my_inherited_widget.dart';

class ContentListNav extends StatefulWidget {
  const ContentListNav({Key key}) : super(key: key);

  @override
  _ContentListNavState createState() => _ContentListNavState();
}

class _ContentListNavState extends State<ContentListNav>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  TabController _tabController;

  int index = 0;
  List categories;
  @override
  void initState() {
    super.initState();

    CategoriesGetHttp(28, (result) {
      categories = CategoryModel.fromJson(result).categories;
      print("categories==" + categories.toString());

      _tabController = TabController(vsync: this, length: categories.length);
      _tabController.addListener(() {
        if (_tabController.animation?.value == _tabController.index) {
          setState(() {
            index = _tabController.index;
          });
        }
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (null != categories && categories.length > 0)
        ? Container(
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
          )
        : Container();
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
        tabs: categories.map((e) => Tab(text: e.categoryName)).toList(),
      );

  Widget _buildTableBarView() {
    return MyInheritedWidget(data: categories[index], child: ContentTabItem());
  }
}
