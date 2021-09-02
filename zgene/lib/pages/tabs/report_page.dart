import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/report/report_list_page.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/util/ui_uitls.dart';

import 'home_page.dart';

///首页报告
class ReportPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() => _ReportPageState();
}

class _ReportPageState extends BaseWidgetState<ReportPage> {
  var lists = [
    [1, 2, 3, 4],
    [1, 2, 3, 4],
    [1, 2, 3, 4],
    [1, 2, 3, 4],
    [1, 2, 3, 4],
  ];
  var banners = ["1", "2", "3"];
  ScrollController _controller = new ScrollController();

  ///0 : 女    1：男
  var type = 0;

  //顶部渐变
  double appBarAlphas = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showBaseHead = false;
    showHead = false;
    isListPage = true;
    // setWantKeepAlive = true;
    backImgPath = "assets/images/home/bg_home.png";

    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      _onScroll(_controller.offset);
    });
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    if (appBarAlphas != alpha) {
      setState(() {
        appBarAlphas = alpha;
      });
    }
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        _appBar,
        _tip,
        Expanded(
          child: ListView(
            controller: _controller,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
            children: lists.map((e) {
              return _items(e);
            }).toList()
              ..add(_bottomBanner),
          ),
        ),
      ]),
    );
  }

  Widget get _bottomBanner {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, top: 24, right: 15, bottom: 8),
            child: Text(
              "精选报告",
              style: TextStyle(
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          SizedBox(
            height: 128,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.fromLTRB(0, 15, 16, 0),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: banners.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      UiUitls.showToast("跳转");
                    },
                    // child: Image.network(
                    //   bannerList[index],
                    //   fit: BoxFit.fill,
                    // ),
                    child: Container(
                      width: 256,
                      padding: EdgeInsets.fromLTRB(16, 16, 90, 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          gradient: LinearGradient(colors: [
                            Color(0xFFFF5D66),
                            Color(0xFFFFB254),
                          ])
                          // image: DecorationImage(
                          //     image: NetworkImage("assets/images/banner.png"))
                          ),
                      margin: EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            "怎样的运动与饮食方案最适合我？",
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16),
                          )),
                          Text(
                            "共12项",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _items(list) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 24),
            child: Text(
              "探索基因蓝图",
              style: TextStyle(
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          GridView.builder(
              padding: EdgeInsets.fromLTRB(16, 15, 16, 0),
              physics: NeverScrollableScrollPhysics(),
              //增加
              shrinkWrap: true,
              //增加
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //条目个数
                  mainAxisSpacing: 16, //主轴间距
                  crossAxisSpacing: 16, //交叉轴间距
                  childAspectRatio: 0.86),
              itemCount: list.length,
              itemBuilder: (context, i) {
                return _item(list[i]);
              }),
        ],
      ),
    );
  }

  Widget _item(index) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(context, ReportListPage());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: (Column(
          children: [
            Image.asset(
              "assets/images/report/icon_geti.png",
              height: 76,
              width: 76,
            ),
            Text(
              "个体特征",
              style: TextStyle(
                fontSize: 14.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
              ),
            ),
            Text(
              "共33项",
              style: TextStyle(
                fontSize: 12.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorConstant.Text_8E9AB,
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget get _tip {
    return GestureDetector(
      onTap: () {
        UiUitls.showToast("报告");
      },
      child: Container(
        width: double.infinity,
        height: 32,
        decoration: BoxDecoration(color: ColorConstant.TextMainColor_10per),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "此示例报告[标准/${type == 0 ? "女" : "男"}]，请以真实检测数据为准。",
              style: TextStyle(
                  fontSize: 13,
                  color: ColorConstant.TextMainColor,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              " 去购买>>",
              style: TextStyle(
                  fontSize: 13,
                  color: ColorConstant.bg_EA4335,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget get _appBar {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB((appBarAlphas * 255).toInt(), 255, 255, 255),
      ),
      height: 55.h + MediaQuery.of(context).padding.top,
      child: Stack(
        children: [
          Positioned(
            left: 16.w,
            top: MediaQuery.of(context).padding.top,
            child: Container(
              height: 55.h,
              child: Center(
                child: Text(
                  "示例报告",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.TextMainBlack,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16.w,
            top: MediaQuery.of(context).padding.top,
            child: GestureDetector(
              onTap: () async {
                var type = await _showModalBottomSheet();
              },
              child: Container(
                height: 55.h,
                child: Center(
                  child: Image.asset(
                    "assets/images/report/icon_qiehuan.png",
                    height: 36,
                    width: 36,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 弹出底部菜单列表模态对话框
  Future<int> _showModalBottomSheet() async {
    return await showModalBottomSheet<int>(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(left: 22, top: 20, right: 22),
          height: 230,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "切换检测人",
                style: TextStyle(
                    fontSize: 18,
                    color: ColorConstant.TextMainBlack,
                    fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  if (type == 0) {
                    setState(() {
                      type = 1;
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    "标准/男",
                    style: TextStyle(
                        fontSize: 18,
                        color: ColorConstant.TextMainBlack,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: ColorConstant.Divider,
              ),
              GestureDetector(
                onTap: () {
                  if (type == 1) {
                    setState(() {
                      type = 0;
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Container(
                    height: 60,
                    color: Colors.transparent,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "标准/女",
                      style: TextStyle(
                          fontSize: 18,
                          color: ColorConstant.TextMainBlack,
                          fontWeight: FontWeight.w600),
                    )),
              )
            ],
          ),
        );
      },
    );
  }
}
