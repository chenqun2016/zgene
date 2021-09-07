import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/my/my_pdf_viewer_page.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/refresh_config_utils.dart';

class MyReportPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() => _MyReportPageState();
}

class _MyReportPageState extends BaseWidgetState {
  EasyRefreshController _easyController;
  List list = [];

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    pageWidgetTitle = "检测报告";
    backImgPath = "assets/images/mine/img_bg_my.png";
    isListPage = true;
    _easyController = EasyRefreshController();
  }

  Future<String> getData() async {
    return Future.delayed(Duration(seconds: 2), () => "我是从互联网上获取的数据");
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), bottom: Radius.circular(40)),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        color: Colors.white70,
      ),
      child: EasyRefresh(
        // 是否开启控制结束加载
        enableControlFinishLoad: false,
        firstRefresh: true,
        // 控制器
        emptyWidget: _emptyWidget,
        controller: _easyController,
        header: RefreshConfigUtils.classicalHeader(),
        child: _listView,
        //下拉刷新事件回调
        onRefresh: () async {
          // page = 1;
          // // 获取数据
          // getHttp();
          // await Future.delayed(Duration(seconds: 1), () {
          // 重置刷新状态 【没错，这里用的是resetLoadState】
          if (_easyController != null) {
            _easyController.resetLoadState();
          }
          // });
        },
      ),
    );
  }

  get _emptyWidget {
    return Column(
      children: [
        Divider(
          height: 90,
          color: Colors.transparent,
        ),
        Image.asset(
          "assets/images/mine/img_zhanwubaogao.png",
          height: 140,
          width: 166,
        ),
        Text(
          "暂无报告~",
          style: TextStyle(
              fontSize: 18,
              color: ColorConstant.Text_8E9AB,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget get _listView {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                    image: AssetImage("assets/images/mine/img_my_banner.png"))),
            margin: EdgeInsets.fromLTRB(15, 16, 15, 0),
            padding: EdgeInsets.fromLTRB(30, 26, 0, 24),
            child: Column(
              children: [
                Text(
                  "张三",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "基因检测报告",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 20,
                  color: Colors.transparent,
                ),
                MaterialButton(
                  height: 32,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17)),
                  minWidth: 88,
                  disabledColor: Colors.white,
                  color: Colors.white,
                  onPressed: () {
                    NavigatorUtil.push(context, MyPdfViewerPage("model"));
                  },
                  child: Text("查看报告",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.TextMainColor,
                      )),
                ),
              ],
            ),
          );
        });
  }
}
