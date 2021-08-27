import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/ui_uitls.dart';

///我的消息列表
class MyMessagePage extends StatefulWidget {
  @override
  _MyMessagePageState createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MyMessagePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
        child:emptyView,),
    );
  }

  ///空列表
  Widget get emptyView{
   return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    style: TextStyle(
                        fontSize: 13, color: ColorConstant.TextMainBlack),
                  ),
                ],
              ),
            ],
          ),
          0==1?_listView: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height-213,
            margin: EdgeInsets.only(top:25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child:Column(
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
          ),
        ]
    );
  }

  ///列表
  Widget get _listView {
    return Container(
      margin: EdgeInsets.only(top: 30),
      color: ColorConstant.WhiteColor,
      child: ListView.separated(
        itemCount:3,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return   Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top:25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [

              ],
            ),
          );
        },
        //分割器构造器
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1.0,
            indent: 15,
            endIndent: 15,
            color: ColorConstant.LineMainColor,
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
}
