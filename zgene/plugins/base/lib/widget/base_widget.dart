import 'package:base/widget/my_inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/color_constant.dart';
import 'base_widget_title.dart';

const int APPBAR_SCORLL_OFFSET = 100;

abstract class BaseWidgetState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => setWantKeepAlive;
  //页面是否保存
  bool setWantKeepAlive = false;
  //是否显示返回btn
  bool isShowBack = true;
  //页面是否纯list
  bool isListPage = false;
// 系统自带appbar 的显示与否
  bool showBaseHead = false;
// 自定义appbar 的显示与否
  bool showHead = true;
// appbarView 的高度
  double appBarHeight = 0.0;
// 页面标题
  String pageWidgetTitle = '';
// 页面背景图片
  String backImgPath = '';
  // 页面空态是否显示
  bool nullImgIsHidden = true;
  // 页面空图片
  String nullImgPath = 'assets/images/icon_orderList_null.png';
  // 页面空图片
  String nullImgText = '暂无内容';
  // 页面空图片
// 页面背景颜色
  Color backColor = ColorConstant.BackMainColor;
  // 自定义顶部栏右上角文字按钮 传值为显示textButton
  String customRightBtnText = '';
  // 自定义顶部栏右上角图标按钮 传值为显示iconButton
  String customRightBtnImg = '';
  //顶部渐变
  double appBarAlpha = 0;
  //顶部渐变监听ScrollController
  late ScrollController listeningController;
  dynamic data = {};

  int trans = 0;
  @override
  void initState() {
    super.initState();
    print("lifecycle-initState--" + widget.toStringShort());
    listeningController = ScrollController();
    listeningController.addListener(() {
      if (listeningController.position.pixels.toInt() < APPBAR_SCORLL_OFFSET) {
        trans = listeningController.position.pixels.toInt();
        if (trans < 0) trans = 0;
        setState(() {});
      } else {
        if (trans != APPBAR_SCORLL_OFFSET) {
          trans = APPBAR_SCORLL_OFFSET;
          setState(() {});
        }
      }
    });
    customInitState();
  }

  @override
  void dispose() {
    super.dispose();
    print("lifecycle-dispose--" + widget.toStringShort());
    // FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void didChangeDependencies() {
    print("lifecycle-didChangeDependencies--" + widget.toStringShort());
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    print("lifecycle-didUpdateWidget--" + widget.toStringShort());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print("lifecycle-deactivate--" + widget.toStringShort());
    super.deactivate();
  }

  void customInitState() {}

  Widget viewCustomHeadBody() {
    return showHead
        ? MyInheritedWidget(
            data: trans,
            child: BaseWidgetTitle(
              isShowBack: isShowBack,
              customHeaderBack: customHeaderBack(),
              headerRightBtn: headerRightBtn(),
              pageWidgetTitle: pageWidgetTitle,
            ))
        : Container();
  }

  /// 页面视图的主体部分
  Widget customBuildBody(BuildContext context) {
    return Container();
  }

  /// 配置页面底部bottomNavigationBar
  Widget? customBottomNavigationBar() {
    return null;
  }

  /// 配置页面头部标题
  Widget customAppBarTitle() {
    return Text(pageWidgetTitle);
  }

  /// 配置页面头部的 bottom
  PreferredSizeWidget? customAppBarBottom() {
    return null;
  }

  /// 配置页面头部内容
  Widget? customAppBarSpace() {
    return null;
  }

  /// 设置头部右上角icon
  List<Widget>? customAppBarActions() {
    return null;
  }

  /// 顶部返回和实体返回按键的响应事件
  Future customBackClick() {
    Navigator.pop(context);
    return Future.value(true);
  }

  /// 自定义顶部栏右侧button
  Widget headerRightBtn() {
    if (customRightBtnText != "") {
      return Center(
        child: InkWell(
          onTap: () {
            customRightBtnTap(context);
          },
          child: Text(
            customRightBtnText,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              color: ColorConstant.TextMainBlack,
            ),
          ),
        ),
      );
    } else if (customRightBtnImg != "") {
      return MaterialButton(
          onPressed: () {
            customRightBtnTap(context);
          },
          padding: EdgeInsets.zero,
          height: 40.h,
          minWidth: 40.w,
          child: Image(
            image: AssetImage(customRightBtnImg),
            height: 40.h,
            width: 40.w,
            fit: BoxFit.fill,
          ));
    } else {
      return Container();
    }
  }

  /// 顶部右侧自定义按键的响应事件
  Future? customRightBtnTap(BuildContext context) {}

  /// 配置页面头部返回
  Widget customHeaderBack() {
    return IconButton(
        onPressed: () {
          customBackClick();
        },
        icon: Image(
          image: AssetImage("assets/images/icon_base_backArrow.png"),
          // height: 40.w,
          // width: 40.w,
          fit: BoxFit.fill,
        ));
  }

  /// 配置页面头部返回
  Widget customNullImg() {
    return Container(
      child: Column(
        children: [
          Image(
            image: AssetImage(nullImgPath),
            height: 140.w,
            width: 166.w,
            fit: BoxFit.fill,
          ),
          Container(
            child: Text(
              nullImgText,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: ColorConstant.Text_8E9AB,
              ),
            ),
          )
        ],
      ),
    );
  }

// AppBar 的widget
  PreferredSizeWidget? _viewAppBar() {
    final _appbar = AppBar(
      title: customAppBarTitle(),
      bottom: customAppBarBottom(),
      flexibleSpace: customAppBarSpace(),
      centerTitle: true,
      actions: customAppBarActions(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
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

  /// 配置页面头部返回
  Widget customBodyView() {
    if (!isListPage) {
      return Column(
        children: [
          viewCustomHeadBody(),
          Expanded(
            child: Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    ((showBaseHead || showHead) ? 55.h : 0) -
                    MediaQuery.of(context).padding.top,
                child: CustomScrollView(
                  controller: listeningController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [customBuildBody(context)],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  left: 105.w,
                  right: 105.w,
                  top: 218.h,
                  child: Offstage(
                      offstage: nullImgIsHidden, child: customNullImg()))
            ]),
          ),
        ],
      );
    } else {
      return Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            viewCustomHeadBody(),
            Expanded(
                flex: 1,
                child: Container(
                    height: MediaQuery.of(context).size.height -
                        ((showBaseHead || showHead) ? 55.h : 0) -
                        MediaQuery.of(context).padding.top,
                    child: customBuildBody(context)))
          ],
        ),
        Positioned(
            left: 105.w,
            right: 105.w,
            top: 218.h,
            child: Offstage(offstage: nullImgIsHidden, child: customNullImg()))
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("lifecycle-build--" + widget.toStringShort());
    super.build(context);
    // selfContext = context;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        orientation: Orientation.portrait);
    return Stack(children: [
      Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: backImgPath != ''
                ? BoxDecoration(
                    color: backColor,
                    image: DecorationImage(
                      image: AssetImage(backImgPath),
                      fit: BoxFit.fill,
                    ),
                  )
                : BoxDecoration(
                    color: backColor,
                  ),
          )),
      Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: showBaseHead == true ? _viewAppBar() : null,
        body: GestureDetector(
            onTap: () {
              print("点击屏幕");
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              //   decoration: backImgPath != ''
              //       ? BoxDecoration(
              //           image: DecorationImage(
              //             image: AssetImage(backImgPath),
              //             fit: BoxFit.fill,
              //           ),
              //         )
              //       : null,
              child: customBodyView(),
            )),
        bottomNavigationBar: customBottomNavigationBar(),
      ),
    ]);
  }
}
