import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';

abstract class BaseWidget extends StatefulWidget {
  @override
  BaseWidgetState createState() => getState();
  BaseWidgetState getState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
// class BaseWidgetState extends State with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
// 系统自带appbar 的显示与否
  bool showBaseHead = false;
// 自定义appbar 的显示与否
  bool showHead = true;
// appbarView 的高度
  double appBarHeight = 0.0;
// 页面标题
  String pageWidgetTitle = '';

  String backImgPath = '';

  Color backColor = ColorConstant.BackMainColor;

  // assets/login/icon_backArrow.png

  // String showBackImg = '';

  @override
  void initState() {
    super.initState();
    pageWidgetInitState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void pageWidgetInitState() {}

  Widget viewCustomHeadBody() {
    return showHead
        ? Container(
            height: 97,
            child: Stack(
              children: [
                Positioned(left: 16, top: 42, child: customHeaderBack()),
                Positioned(
                  left: 80,
                  right: 80,
                  top: 56,
                  child: Text(
                    pageWidgetTitle,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.MainBlack,
                    ),
                  ),
                ),
                Positioned(right: 16, top: 42, child: headerRightBtn())
              ],
            ),
          )
        : Container();
  }

  /// 页面视图的主体部分
  Widget viewPageBody() {
    return null;
  }

  Widget headerRightBtn() {
    return Container();
  }

  /// 配置页面底部bottomNavigationBar
  Widget viewBottomNavigationBar() {
    return null;
  }

  /// 配置页面头部标题
  Widget AppBarTitle() {
    return Text(pageWidgetTitle);
  }

  /// 配置页面头部的 bottom
  PreferredSizeWidget AppBarBottom() {
    return null;
  }

  /// 配置页面头部内容
  Widget AppBarSpace() {
    return null;
  }

  /// 设置头部右上角icon
  List<Widget> AppBarActions() {
    return null;
  }

  /// 顶部返回和实体返回按键的响应事件
  Future myBackClick() {
    return Future.value(true);
  }

  /// 配置页面头部内容
  Widget customHeaderBack() {
    return IconButton(
        onPressed: () {
          myBackClick();
        },
        icon: Image(
          image: AssetImage("assets/images/icon_base_backArrow.png"),
          height: 40,
          width: 40,
          fit: BoxFit.fill,
        ));
  }

// AppBar 的widget
  Widget _viewAppBar() {
    final _appbar = AppBar(
      title: AppBarTitle(),
      bottom: AppBarBottom(),
      flexibleSpace: AppBarSpace(),
      centerTitle: true,
      actions: AppBarActions(),
    );
    if (appBarHeight == null || appBarHeight == 0.0) {
      return _appbar;
    }
// 传入了appbar的高度，返回定制appbar的高度
    return PreferredSize(
      child: _appbar,
      preferredSize: Size.fromHeight(appBarHeight),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        orientation: Orientation.portrait);
    return Scaffold(
      // backgroundColor: backColor,
      appBar: showBaseHead == true ? _viewAppBar() : null,
      body: Container(
          decoration: backImgPath != ''
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(backImgPath),
                    fit: BoxFit.fill,
                  ),
                )
              : null,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [viewCustomHeadBody(), viewPageBody()],
                  ),
                ),
              )
            ],
          )),
      bottomNavigationBar: viewBottomNavigationBar(),
    );
  }
}
