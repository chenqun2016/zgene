import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/my_report_list_page.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/widget/base_web.dart';

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

  Future<void> getDatas() async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }

    HttpUtils.requestHttp(
      ApiConstant.reports,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        EasyLoading.dismiss();
        List l = result;
        list.clear();
        l.forEach((element) {
          list.add(MyReportListPage.fromJson(element));
        });
        setState(() {});
      },
      onError: (code, error) {
        EasyLoading.showError(error);
      },
    );
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
        emptyWidget: list.length <= 0 ? _emptyWidget : null,
        // 控制器
        controller: _easyController,
        header: BallPulseHeader(),
        child: _listView,
        //下拉刷新事件回调
        onRefresh: () async {
          // page = 1;
          // // 获取数据
          getDatas();
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
          MyReportListPage bean = list[index];
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                    image: AssetImage(index % 2 == 0
                        ? "assets/images/report/icon_baogao1.png"
                        : "assets/images/report/icon_baogao2.png"))),
            margin: EdgeInsets.fromLTRB(15, 16, 15, 0),
            padding: EdgeInsets.fromLTRB(30, 26, 0, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bean.targetName,
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
                    NavigatorUtil.push(
                        context,
                        BaseWebView(
                          url: ApiConstant.getPDFH5DetailUrl(bean.id),
                          title: "${bean.targetName}的基因检测报告",
                          isShare: false,
                        ));
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
