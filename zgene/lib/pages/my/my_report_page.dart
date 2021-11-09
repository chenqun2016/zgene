import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/event/event_bus.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/report_page_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/my/acquisition_progress.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';

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
    Map<String, dynamic> map = new HashMap();
    map['page'] = page;
    map['size'] = 20;

    HttpUtils.requestHttp(
      ApiConstant.collector_list,
      method: HttpUtils.GET,
      parameters: map,
      onSuccess: (result) async {
        print(result);
        EasyLoading.dismiss();
        List l = result;
        if (page == 1) {
          list.clear();
          l.forEach((element) {
            list.add(ReportPageModel.fromJson(element));
          });
        } else {
          l.forEach((element) {
            list.add(ReportPageModel.fromJson(element));
          });
        }

        setState(() {});
      },
      onError: (code, error) {
        EasyLoading.showError(error);
      },
    );
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return EasyRefresh(
      // 是否开启控制结束加载
      enableControlFinishLoad: false,
      firstRefresh: true,
      emptyWidget: list.length <= 0 ? _emptyWidget : null,
      // 控制器
      controller: _easyController,
      header: BallPulseHeader(),
      footer: BallPulseFooter(),
      child: _listView,
      //下拉刷新事件回调
      onRefresh: () async {
        page = 1;
        // // 获取数据
        getDatas();
        // await Future.delayed(Duration(seconds: 1), () {
        // 重置刷新状态 【没错，这里用的是resetLoadState】
        if (_easyController != null) {
          _easyController.resetLoadState();
        }
        // });
      },
      onLoad: () async {
        page += 1;
        getDatas();
        if (_easyController != null) {
          _easyController.finishLoad();
        }
      },
    );
  }

  int page = 1;
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
          ReportPageModel bean = list[index];
          print(CommonUtils.splicingImageId(
              "reportbg/" + bean.collectorBatch.productId.toString()));
          return Container(
            margin: EdgeInsets.fromLTRB(15, 16, 15, 0),
            child: Stack(
              children: [
                CachedNetworkImage(
                  width: double.infinity,
                  // 图片地址
                  imageUrl: CommonUtils.splicingImageId(
                      "reportbg/" + bean.collectorBatch.productId.toString()),
                  // 填充方式为cover
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/report/icon_baogao1.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 26, 0, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 70,
                        child: Text(
                          bean.targetName == null ? "" : bean.targetName,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          bean.collectorBatch.productName != null
                              ? bean.collectorBatch.productName
                              : "ZGene检测",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        height: 20,
                        color: Colors.transparent,
                      ),
                      Row(
                        children: [
                          Text(
                            "采集器编号：" +
                                (bean.serialNum == null ? "" : bean.serialNum),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Container()),
                          Container(
                            margin: EdgeInsets.only(right: 26),
                            child: MaterialButton(
                              height: 32,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17)),
                              minWidth: 88,
                              disabledColor: Colors.white,
                              color: Colors.white,
                              onPressed: () {
                                // NavigatorUtil.push(
                                //     context,
                                //     BaseWebView(
                                //       url: ApiConstant.getPDFH5DetailUrl(bean.id),
                                //       title: "${bean.targetName}的基因检测报告",
                                //       isShare: false,
                                //     ));
                                // if (bean.status == 80) {
                                //
                                // } else {
                                NavigatorUtil.push(
                                    context,
                                    acqusitionProgressPage(
                                      id: bean.id == null ? 0 : bean.id,
                                      title: (bean.targetName == null
                                              ? ""
                                              : bean.targetName) +
                                          "的检测进度",
                                    ));
                                // }
                              },
                              child: Text(bean.status == 80 ? "查看报告" : "检测进度",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.TextMainColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
