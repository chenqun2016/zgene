import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/app_notification.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/login/bindPhone_login.dart';
import 'package:zgene/pages/my/my_address_list.dart';
import 'package:zgene/pages/my/my_change_phone.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/dia_log.dart';
import 'package:zgene/util/notification_utils.dart';
import 'package:zgene/util/sp_utils.dart';
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

    weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
      if (res is WeChatAuthResponse) {
        int errCode = res.errCode;
        // MyLogUtil.d('微信登录返回值：ErrCode :$errCode  code:${res.code}');
        if (errCode == 0) {
          String code = res.code;
          print('wxwxwxwxwxwxwx' + code);
          //把微信登录返回的code传给后台，剩下的事就交给后台处理
          wxLoginHttp(code);
          // showToast("用户同意授权成功");
        } else if (errCode == -4) {
          // showToast("用户拒绝授权");
          print('wxwxwxwxwxwxwx用户拒绝授权');
        } else if (errCode == -2) {
          // showToast("用户取消授权");
          print('wxwxwxwxwxwxwx用户取消授权');
        }
      }
    });
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
          Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              height: 55,
              child: RaisedButton(
                color: ColorConstant.WhiteColor,
                child: Text(
                  "退出登录",
                  style: TextStyle(
                    color: ColorConstant.TextMainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                onPressed: () {
                  _onTapEvent(8);
                },
              )),
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
                    SpUtils().getStorageDefault(SpConstant.isBindWx, false)
                        ? "已绑定"
                        : "去绑定",
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
                  right: 22,
                  top: 12,
                  child: Text(
                    SpUtils()
                        .getStorageDefault(SpConstant.UserMobile, "")
                        .toString(),
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
        SpUtils().getStorageDefault(SpConstant.isBindWx, false)
            ? showDialog(
                context: context,
                builder: (context) {
                  return MyDialog(
                    title: "确认解绑微信吗?",
                    img: "assets/images/mine/icon_set_ unbundling.png",
                    falseText: "取消",
                    tureText: "确认",
                  );
                }).then((value) => {
                  if (value) {unbindWX()}
                })
            : bindWX();

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
        //清除登录信息
        var spUtils = SpUtils();
        spUtils.setStorage(SpConstant.Token, "");
        spUtils.setStorage(SpConstant.IsLogin, false);
        spUtils.setStorage(SpConstant.Uid, 0);
        spUtils.setStorage(SpConstant.UserMobile, 0);
        //清除用户信息
        spUtils.setStorage(SpConstant.UserName, "");
        spUtils.setStorage(SpConstant.UserAvatar, "");
        HttpUtils.clear();

        EasyLoading.showSuccess('退出登录成功');
        NotificationCenter.instance
            .postNotification(NotificationName.GetUserInfo, null);
        Navigator.pop(context);

        break;
    }
  }

  void bindWX() {
    sendWeChatAuth(scope: "snsapi_userinfo", state: "sivms_state").then((data) {
      setState(() {
        print("拉取微信用户信息：" + data.toString());
      });
    }).catchError((e) {
      print('weChatLogin  e  $e');
    });
  }

  void wxLoginHttp(String code) {
    Map<String, dynamic> map = new HashMap();
    map["code"] = code;

    EasyLoading.show(status: 'loading...');

    HttpUtils.requestHttp(
      ApiConstant.bind_wx,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) {
        print(data);
        EasyLoading.showSuccess("绑定成功");
      },
      onError: (code, error) {
        print("cao");
        EasyLoading.showError(error ?? "");
      },
    );
  }

  void unbindWX() {
    EasyLoading.show(status: 'loading...');

    HttpUtils.requestHttp(
      ApiConstant.unbind_wx,
      method: HttpUtils.POST,
      onSuccess: (data) {
        print(data);
        EasyLoading.showSuccess("解绑成功");
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
      },
    );
  }
}
