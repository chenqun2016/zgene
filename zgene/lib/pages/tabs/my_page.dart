import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/login/main_login.dart';
import 'package:zgene/pages/my/my_info_page.dart';
import 'package:zgene/pages/my/my_message_list.dart';
import 'package:zgene/util/ui_uitls.dart';

///我的
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/mine/img_bg_my.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  _onTapEvent(1);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 45, 0, 0),
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_message.png"),
                    height: 42,
                    width: 42,
                  ),
                  alignment: Alignment.topRight,
                ),
              ),
              _getMyInfo(),
              Visibility(
                visible: true,
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Image(
                    image: AssetImage("assets/images/mine/img_my_banner.png"),
                    height: 80,
                    width: double.infinity,
                  ),
                ),
              ),
              _getMyOrder(),
              _getProductPurchase(),
              _getSet(),
            ],
          ),
        ),
      ),
    );
  }

  ///个人信息
  _getMyInfo() {
    return GestureDetector(
      onTap: (){
        _onTapEvent(2);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 22),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 14),
                  child: Image(
                    image: AssetImage("assets/images/mine/img_my_avatar.png"),
                    height: 66,
                    width: 66,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "登录/注册",
                      style: TextStyle(
                        fontSize: 28,
                        color: ColorConstant.TextMainBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Z基因帮你解锁出厂设置",
                      style: TextStyle(
                        fontSize: 15,
                        color: ColorConstant.TextSecondColor,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 20,
              child: Image(
                image: AssetImage("assets/images/mine/icon_my_name_right.png"),
                height: 20,
                width: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///我的订单板块
  _getMyOrder() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 11),
      margin: EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            child: GestureDetector(
              onTap: (){
                _onTapEvent(3);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/mine/icon_wodedingdan.png"),
                    height: 82,
                    width: 82,
                  ),
                  Text(
                    "我的订单",
                    style: TextStyle(
                        fontSize: 13, color: ColorConstant.TextThreeColor),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: (){
                _onTapEvent(4);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/mine/icon_bangding.png"),
                    height: 82,
                    width: 82,
                  ),
                  Text(
                    "绑定采集器",
                    style: TextStyle(
                        fontSize: 13, color: ColorConstant.TextThreeColor),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: (){
                _onTapEvent(5);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/mine/icon_yueduzhinan.png"),
                    height: 82,
                    width: 82,
                  ),
                  Text(
                    "回寄采集器",
                    style: TextStyle(
                        fontSize: 13, color: ColorConstant.TextThreeColor),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///产品购买板块
  _getProductPurchase() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 7, 16, 7),
      margin: EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              _onTapEvent(6);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "产品购买",
                      style: TextStyle(
                          fontSize: 15, color:Color(0xFF112950)),
                    )),
                Positioned(
                  right: 0,
                  top:15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              _onTapEvent(7);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "我的报告",
                      style: TextStyle(
                          fontSize: 15, color:Color(0xFF112950)),
                    )),
                Positioned(
                  right: 0,
                  top:15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///设置板块
  _getSet() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 11, 16, 11),
      margin: EdgeInsets.only(bottom: 80),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              _onTapEvent(8);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "设置",
                      style: TextStyle(
                          fontSize: 15, color:Color(0xFF112950)),
                    )),
                Positioned(
                  right: 0,
                  top:15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              _onTapEvent(9);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "联系客服",
                      style: TextStyle(
                          fontSize: 15, color:Color(0xFF112950)),
                    )),
                Positioned(
                  right: 0,
                  top:15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              _onTapEvent(10);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "常见问题",
                      style: TextStyle(
                          fontSize: 15, color:Color(0xFF112950)),
                    )),
                Positioned(
                  right: 0,
                  top:15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              _onTapEvent(11);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "关于Z基因",
                      style: TextStyle(
                          fontSize: 15, color:Color(0xFF112950)),
                    )),
                Positioned(
                  right: 0,
                  top:15,
                  child: Image(
                    image: AssetImage("assets/images/mine/icon_my_right.png"),
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///点击事件
  _onTapEvent(index){
    switch(index){
      case 1://消息
        NavigatorUtil.push(context, MyMessagePage());
        break;
      case 2://个人信息
        NavigatorUtil.push(context, MyInfoPage());
        break;
      case 3://我的订单
        NavigatorUtil.push(context, MainLoginPage());
        break;
      case 4://绑定采集器
        UiUitls.showToast("绑定采集器");
        break;
      case 5://回寄采集器
        UiUitls.showToast("回寄采集器");
        break;
      case 6://产品购买
        UiUitls.showToast("产品购买");
        break;
      case 7://我的报告
        UiUitls.showToast("我的报告");
        break;
      case 8://设置
        UiUitls.showToast("设置");
        break;
      case 9://联系客服
        UiUitls.showToast("联系客服");
        break;
      case 10://常见问题
        UiUitls.showToast("常见问题");
        break;
      case 11://关于Z基因
        UiUitls.showToast("关于Z基因");
        break;
    }
  }
}
