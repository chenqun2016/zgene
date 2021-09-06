import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/my/my_address_list.dart';
import 'package:zgene/pages/my/my_change_phone.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/dia_log.dart';
import 'package:zgene/util/ui_uitls.dart';

import 'account_security.dart';

///我的设置
class MySetPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _MySetPageState();
  }
}

class _MySetPageState extends BaseWidgetState<MySetPage> {
  var textStyle;

  @override
  void initState() {
    super.initState();
    pageWidgetTitle = "设置";
    backImgPath = "assets/images/mine/img_bg_my.png";
    textStyle = TextStyle(
      fontSize: 15,
      color: Color(0xFF112950),
      fontWeight: FontWeight.w500,
    );
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height - 100,
      child: Stack(
        children: [
          Column(
            children: [
              _getAccountSet(),
              _getOtherSet(),
            ],
          ),
          // Positioned(
          //     bottom: 40,
          //     left: 6,
          //     right: 6,
          //     height: 55,
          //     child: RaisedButton(
          //       color: ColorConstant.TextMainColor,
          //       child: Text(
          //         "退出登录",
          //         style: TextStyle(
          //           color: ColorConstant.WhiteColor,
          //           fontSize: 18,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(40.0)),
          //       onPressed: () {
          //         _onTapEvent(8);
          //       },
          //     )),
        ],
      ),
    );
  }

  ///设置板块
  Widget _getAccountSet() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 11, 16, 11),
      margin: EdgeInsets.fromLTRB(15, 5, 15, 8),
      width: double.infinity,
      decoration: new BoxDecoration(
        color: ColorConstant.WhiteColorB2,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        //设置四周边框
        border: new Border.all(width: 1, color: ColorConstant.WhiteColor),
      ),
      child: Column(
        children: [
          // GestureDetector(
          //   onTap: () {
          //     _onTapEvent(1);
          //   },
          //   behavior: HitTestBehavior.opaque,
          //   child: Stack(
          //     children: [
          //       Container(
          //           width: double.infinity,
          //           height: 45,
          //           alignment: Alignment.centerLeft,
          //           child: Text(
          //             "用户名",
          //             style: textStyle,
          //           )),
          //       Positioned(
          //         right: 0,
          //         top: 15,
          //         child: Image(
          //           image: AssetImage("assets/images/mine/icon_my_right.png"),
          //           height: 16,
          //           width: 16,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              _onTapEvent(2);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "微信",
                      style: textStyle,
                    )),
                Positioned(
                  right: 22,
                  top: 12,
                  child: Text(
                    "绑定",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstant.TextThreeColor,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 15,
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
            onTap: () {
              _onTapEvent(3);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "手机",
                      style: textStyle,
                    )),
                Positioned(
                  right: 0,
                  top: 15,
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
            onTap: () {
              _onTapEvent(4);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "地址管理",
                      style: textStyle,
                    )),
                Positioned(
                  right: 0,
                  top: 15,
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

  ///其他设置板块
  Widget _getOtherSet() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 11, 16, 11),
      margin: EdgeInsets.fromLTRB(15, 5, 15, 8),
      width: double.infinity,
      decoration: new BoxDecoration(
        color: ColorConstant.WhiteColorB2,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        //设置四周边框
        border: new Border.all(width: 1, color: ColorConstant.WhiteColor),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _onTapEvent(5);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "推送设置",
                      style: textStyle,
                    )),
                Positioned(
                  right: 0,
                  top: 15,
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
            onTap: () {
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
                      "隐私协议",
                      style: textStyle,
                    )),
                Positioned(
                  right: 0,
                  top: 15,
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
            onTap: () {
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
                      "账号安全",
                      style: textStyle,
                    )),
                Positioned(
                  right: 0,
                  top: 15,
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
  _onTapEvent(index) {
    switch (index) {
      // case 1: //用户名
      //   UiUitls.showToast("用户名");
      //   break;
      case 2: //微信
        showDialog(
            context: context,
            builder: (context) {
              return MyDialog(
                title: "确认解绑微信吗?",
                img: "assets/images/mine/icon_set_ unbundling.png",
                falseText: "取消",
                tureText: "确认",
              );
            }).then((value) => {
              if (value) {print("点击了确定")}
            });

        break;
      case 3: //手机
        NavigatorUtil.push(context, ChangePhonePage());
        break;
      case 4: //收货地址
        NavigatorUtil.push(context, MyAddressListPage());
        break;
      case 5: //推送设置
        UiUitls.showToast("推送设置");
        break;
      case 6: //隐私政策
        UiUitls.showToast("隐私政策");
        break;
      case 7: //账号安全
        NavigatorUtil.push(context, accountSecurityPage());
        break;
      case 8: //退出登录
        UiUitls.showToast("退出登录");
        break;
    }
  }
}
