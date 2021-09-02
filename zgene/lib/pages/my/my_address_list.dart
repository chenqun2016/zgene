import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/address_list_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/my/order_detail.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/refresh_config_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

///我的地址列表
class MyAddressListPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _MyAddressListPageState();
  }
}

class _MyAddressListPageState extends BaseWidgetState<MyAddressListPage> {
  List list = [];
  List tempList = [];
  int page = 1;
  int errorCode = 0; //0.正常 1.暂无数据 2.错误 3.没有网络
  EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();

    pageWidgetTitle = "地址管理";
    backImgPath = "assets/images/mine/img_bg_my.png";
    customRightBtnText = "添加";
    isListPage = true;
    // getHttp();
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return errorCode != 0
        ? UiUitls.getErrorPage(
            context: context,
            type: errorCode,
            onClick: () {
              // if (lastTime == null) {
              //   lastTime = DateTime.now();
              //   page = 1;
              //   getHttp();
              // } else {
              //   //可以点击
              //   if (TimeUtils.intervalClick(lastTime, 2)) {
              //     lastTime = DateTime.now();
              //     page = 1;
              //     getHttp();
              //   }
              // }
            })
        : EasyRefresh(
            // 是否开启控制结束加载
            enableControlFinishLoad: false,
            firstRefresh: true,
            // 控制器
            controller: _controller,
            header: RefreshConfigUtils.classicalHeader(),
            child: _listView,
            //下拉刷新事件回调
            onRefresh: () async {
              // page = 1;
              // // 获取数据
              // getHttp();
              // await Future.delayed(Duration(seconds: 1), () {
              // 重置刷新状态 【没错，这里用的是resetLoadState】
              if (_controller != null) {
                // _controller.resetLoadState();
                getHttp();
              }
              // });
            },
          );
  }

  ///列表
  Widget get _listView {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return getItem(index);
        },
      ),
    );
  }

  Widget getItem(int index) {
    AddressListModel content = list[index];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      margin: EdgeInsets.fromLTRB(16, 5, 16, 10),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                content.rcvName,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF112950),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Text(
                  content.rcvPhone,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5E6F88),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 6),
            child: Text(
              content.province + " " + content.city + " " + content.address,
              // textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF112950),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _onTapEvent(1);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "删除",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8E9AAB),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _onTapEvent(2);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 8, left: 15),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "编辑",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8E9AAB),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void getHttp() async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }
    // EasyLoading.show(status: 'loading...');

    HttpUtils.requestHttp(
      ApiConstant.userAddresses,
      // parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        print(result);
        // EasyLoading.dismiss();
        list.clear();
        List<AddressListModel> tempList = result
            .map((m) => new AddressListModel.fromJson(m))
            .toList()
            .cast<AddressListModel>();
        int length = list.length;
        list.insertAll(length, tempList);
        setState(() {});
      },
      onError: (code, error) {
        EasyLoading.showError(error);
      },
    );
  }

  @override
  rightBtnTap(BuildContext context) {
    UiUitls.showToast("添加");
  }

  ///点击事件
  _onTapEvent(index) {
    switch (index) {
      case 1: //删除
        UiUitls.showToast("删除");
        break;
      case 2: //编辑
        UiUitls.showToast("编辑");
        break;
    }
  }
}
