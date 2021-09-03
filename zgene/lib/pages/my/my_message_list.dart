import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/refresh_config_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

///我的消息列表
class MyMessagePage extends StatefulWidget {

  @override
  _MyMessagePageState createState() => _MyMessagePageState();

}

class _MyMessagePageState extends State<MyMessagePage>{
  int errorCode = 0; //0.正常 1.暂无数据 2.错误 3.没有网络
  List list = [];
  List tempList = [];
  int page = 1;


  @override
  void initState() {
    super.initState();
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
        child: emptyView,
      ),
    );
  }

  ///空列表
  Widget get emptyView {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 40,
        margin: EdgeInsets.only(top: 48),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              width: 40,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  _onTapEvent(1);
                },
                behavior: HitTestBehavior.opaque,
                child: Image(
                  image: AssetImage("assets/images/mine/icon_back.png"),
                  height: 40,
                  width: 40,
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 46),
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/images/mine/icon_message_news.png"),
                  height: 82,
                  width: 82,
                ),
                Text(
                  "公告",
                  style: TextStyle(
                      fontSize: 13, color: ColorConstant.TextMainBlack),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Image(
                image: AssetImage("assets/images/mine/icon_message_notice.png"),
                height: 82,
                width: 82,
              ),
              Text(
                "通知",
                style:
                    TextStyle(fontSize: 13, color: ColorConstant.TextMainBlack),
              ),
            ],
          ),
        ],
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
      margin: EdgeInsets.only(top: 30),
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
                      Positioned(
                        child: Text("我是标题",
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorConstant.TextMainBlack,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      Positioned(
                        right: 0,
                        top: 3,
                        child: Text(
                          "2021.3.18",
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
                  child: Text("我就是内容内容我就是内容内容我就是内容内容我就是内容内容我就是内容内容",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5E6F88),
                      )),
                ),
              ],
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
        Navigator.pop(context);
        break;
      case 2: //完成
        UiUitls.showToast("完成");
        break;
    }
  }

  ///获取消息列表
  getHttp() async {
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
    map["page_size"] = CommonConstant.PAGE_SIZE;

    HttpUtils.requestHttp(
      ApiConstant.messageList,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {

      },
      onError: (code, error) {
      },
    );
  }
}
