import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:flutter/material.dart';
import 'package:zgene/widget/roundunderlinne_tab_indicator.dart';

import 'content_record_list.dart';
import 'my_comment_list_page.dart';

///我的管理（历史收藏评论点赞消费）
class MyManagerPage extends StatefulWidget {
  final Map<String, dynamic> params;

  MyManagerPage(this.params);

  @override
  _MyManagerPageState createState() => _MyManagerPageState();
}

class _MyManagerPageState extends State<MyManagerPage>
    with SingleTickerProviderStateMixin {
  TabController mController;
  List<String> tabList;

  @override
  void initState() {
    super.initState();
    tabList = [
      '历史',
      '收藏',
      '点赞',
      '评论',
      '消费',
    ];
    mController = TabController(
      length: tabList.length,
      vsync: this,
    );
    mController.index=widget.params["index"];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        centerTitle: true,
        toolbarHeight: 35,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image(
            image: AssetImage("assets/images/home/icon_back.png"),
            height: 17,
            width: 17,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: ColorConstant.WhiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 40,
              child: TabBar(
                isScrollable: false,
                //是否可以滚动
                controller: mController,
                indicator: RoundUnderlineTabIndicator(
                    borderSide: BorderSide(
                  width: 2,
                  color: Color(CommonConstant.THEME_COLOR),
                )),
                labelColor: Color(CommonConstant.THEME_COLOR),
                unselectedLabelColor: ColorConstant.TextMainColor,
                indicatorColor: Color(CommonConstant.THEME_COLOR),
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(fontSize: 16.0),
                tabs: tabList.map((item) {
                  return Tab(
                    text: item,
                  );
                }).toList(),
              ),
            ),
            Divider(
              height: 1.0,
              color: ColorConstant.LineMainColor,
            ),
            Expanded(
              child: TabBarView(
                controller: mController,
                children: [
                  ContentRecordList(type:1),
                  ContentRecordList(type:2),
                  ContentRecordList(type:3),
                  MyCommentListPage(),
                  ContentRecordList(type:4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
