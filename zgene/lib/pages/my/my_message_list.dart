import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/message_model.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/date_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

///我的消息列表
class MyMessagePage extends StatefulWidget {
  @override
  _MyMessagePageState createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MyMessagePage> {
  int errorCode = 0; //0.正常 1.暂无数据 2.错误 3.没有网络
  List list = [];
  List tempList = [];
  int type = 0;

  int page = 1;
  EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mine/img_bg_my.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: EasyRefresh(
          // 是否开启控制结束加载
          enableControlFinishLoad: false,
          firstRefresh: true,
          // 控制器
          controller: _controller,
          header: BallPulseHeader(),
          // 自定义顶部上啦加载
          footer: BallPulseFooter(),
          child: emptyView,
          //下拉刷新事件回调
          onRefresh: () async {
            page = 1;
            // 获取数据
            getHttp(type);
            await Future.delayed(Duration(seconds: 1), () {
              // 重置刷新状态 【没错，这里用的是resetLoadState】
              // _controller.resetLoadState();
            });
          },
          // 上拉加载事件回调
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              // 获取数据

              getHttp(type);
              // 结束加载
              // _controller.finishLoad();
            });
          },
        ),
      ),
    );
  }

  ///空列表
  Widget get emptyView {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 40.h,
        margin: EdgeInsets.only(top: 48.h),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              width: 40.h,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  _onTapEvent(1);
                },
                behavior: HitTestBehavior.opaque,
                child: Image(
                  image: AssetImage("assets/images/icon_base_backArrow.png"),
                  height: 40.h,
                  width: 40.h,
                ),
              ),
            ),
            Container(
              child: Text(
                "消息中心",
                style: TextStyle(
                  color: ColorConstant.TextMainBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 17.h),
        decoration: new BoxDecoration(
          color: ColorConstant.WhiteColorB2,
          borderRadius: BorderRadius.all(Radius.circular(20.h)),
          //设置四周边框
          border: new Border.all(width: 1, color: ColorConstant.WhiteColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                page = 1;
                type = 0;
                getHttp(type);
              },
              child: Container(
                margin: EdgeInsets.only(right: 46.h),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage(
                          "assets/images/mine/icon_message_notice.png"),
                      height: 82.h,
                      width: 82.h,
                    ),
                    Text(
                      "通知",
                      style: TextStyle(
                          fontSize: 13, color: ColorConstant.TextMainBlack),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 17.h),
                      child: Text(
                        type == 0 ? "⏤" : "",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.TextMainBlack),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                page = 1;
                type = 9;
                getHttp(type);
              },
              child: Column(
                children: [
                  Image(
                    image:
                        AssetImage("assets/images/mine/icon_message_news.png"),
                    height: 82.h,
                    width: 82.h,
                  ),
                  Text(
                    "公告",
                    style: TextStyle(
                        fontSize: 13, color: ColorConstant.TextMainBlack),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 17.h),
                    child: Text(
                      type == 9 ? "⏤" : "",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.TextMainBlack),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      errorCode != 0
          ? UiUitls.getErrorPage(
              context: context,
              type: errorCode,
              height: MediaQuery.of(context).size.height - 215,
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
          : _listView,
    ]);
  }

  ///暂无数据
  Widget get _noData {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      height: MediaQuery.of(context).size.height - 213,
      margin: EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage("assets/images/img_no_data.png"),
            height: 166,
            width: 140,
          ),
          Text(
            "暂无消息~",
            style: TextStyle(
              color: ColorConstant.Text_8E9AB,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  ///列表
  Widget get _listView {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var content = list[index].content;
          print(index);
          return InkWell(
            onTap: () {
              setMessageRead(list[index].nid);
              print(content.linkType.toString() + "111" + content.linkUrl);
              CommonUtils.toUrl(
                  context: context,
                  type: content.linkType,
                  url: content.linkUrl);
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.fromLTRB(15, 18, 15, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Offstage(
                              offstage: list[index].isRead != 1 ? false : true,
                              child: Text("• ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstant.MainRed,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(content.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstant.TextMainBlack,
                                    fontWeight: FontWeight.w500,
                                  )),
                            )
                          ],
                        ),
                        Positioned(
                          right: 0,
                          top: 3,
                          child: Text(
                            CusDateUtils.getFormatDataS(
                                timeSamp: content.createdAt,
                                format: "yyyy.MM.dd"),
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5E6F88),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    indent: 0,
                    endIndent: 0,
                    color: ColorConstant.LineMainColor,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(content.content,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5E6F88),
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///点击事件
  _onTapEvent(index) {
    switch (index) {
      case 1: //返回
        Navigator.pop(context, 1);
        break;
      case 2: //完成
        UiUitls.showToast("完成");
        break;
    }
  }

  ///获取消息列表
  getHttp(int type) async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      // if (page == 1 && list.length == 0) {
      //   errorCode = 3;
      //   _controller = null;
      //   setState(() {});
      // }
      return;
    }
    Map<String, dynamic> map = new HashMap();
    map["page"] = page;
    map["type"] = type;
    map["page_size"] = CommonConstant.PAGE_SIZE;
    print(map);

    HttpUtils.requestHttp(
      ApiConstant.messageList,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) {
        print(result);
        List<MessageModel> tempList = result
            .map((m) => new MessageModel.fromJson(m))
            .toList()
            .cast<MessageModel>();

        //判断是不是暂无数据
        if (tempList.length == 0 && page == 1 && list.length == 0) {
          errorCode = 1;
          _controller = null;
          setState(() {});
          return;
        }

        //设置正常状态
        if (_controller == null) {
          _controller = EasyRefreshController();
        }
        errorCode = 0;
        if (page == 1) {
          list.clear();
          // clearMessage();
        }
        page++;
        int length = list.length;
        list.insertAll(length, tempList);

        if (tempList.length >= CommonConstant.PAGE_SIZE) {
          print("那里");

          _controller.finishLoad(noMore: false);
          print("noMore:false");
        } else {
          _controller.finishLoad(noMore: true);

          print("noMore:true");
        }

        setState(() {});
      },
      onError: (code, error) {
        if (page == 1 && list.length == 0) {
          errorCode = 2;
          _controller = null;
          setState(() {});
        }
      },
    );
  }

  ///消除消息个数
  clearMessage() async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }
    Map<String, dynamic> map = new HashMap();

    HttpUtils.requestHttp(
      ApiConstant.readMessage,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (result) {
        // print(result.toString());
      },
      onError: (code, error) {
        print(error);
      },
    );
  }

  ///设置消息已读
  setMessageRead(int id) async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }
    print(id);
    Map<String, dynamic> map = new HashMap();
    map['id'] = id;
    HttpUtils.requestHttp(
      ApiConstant.noticeRead,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (result) {
        page = 1;
        getHttp(type);
        print("成功");
      },
      onError: (code, error) {
        print(error);
      },
    );
  }
}
