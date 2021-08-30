import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/refresh_config_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

///我的订单列表
class MyOrderListPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _MyOrderListState();
  }
}

class _MyOrderListState extends BaseWidgetState<MyOrderListPage> {

  EasyRefreshController _controller;
  List list = [];
  List tempList = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    pageWidgetTitle = "我的订单";
    backImgPath = "assets/images/mine/img_bg_my.png";
    customRightBtnText="采集引导";
    isPageList=true;

  }

  @override
  Widget viewPageBody(BuildContext context) {
    return EasyRefresh(
      // 是否开启控制结束加载
      enableControlFinishLoad: false,
      firstRefresh: true,
      // 控制器
      controller: _controller,
      header: RefreshConfigUtils.classicalHeader(),
      // 自定义顶部上啦加载
      footer: RefreshConfigUtils.classicalFooter(),
      child: _listView,
      //下拉刷新事件回调
      onRefresh: () async {
        // page = 1;
        // // 获取数据
        // getHttp();
        // await Future.delayed(Duration(seconds: 1), () {
        //   // 重置刷新状态 【没错，这里用的是resetLoadState】
        //   if (_controller != null) {
        //     _controller.resetLoadState();
        //   }
        // });
      },
      // 上拉加载事件回调
      onLoad: () async {
        // await Future.delayed(Duration(seconds: 1), () {
        //   // 获取数据
        //   getHttp();
        //   // 结束加载
        //   _controller.finishLoad();
        //   // _controller.finishLoad(noMore:true);
        // });
      },
    );
  }

  ///列表
  Widget get _listView {
    return Container(
      margin: EdgeInsets.all(0),
      color: ColorConstant.WhiteColor,
      child:ListView.builder(
        itemCount:3,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 100,
                child: Text("sssssssss"));
        },
      ),
    );
  }

  @override
  rightBtnTap(BuildContext context){
    UiUitls.showToast("dddddd");
  }
}
