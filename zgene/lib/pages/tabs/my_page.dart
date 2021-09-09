import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/app_notification.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/event/event_bus.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/models/msg_event.dart';
import 'package:zgene/models/userInfo_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/bindcollector/bind_collector_page.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/pages/login/main_login.dart';
import 'package:zgene/pages/my/my_about_us.dart';
import 'package:zgene/pages/my/my_about_z.dart';
import 'package:zgene/pages/my/my_commonQus.dart';
import 'package:zgene/pages/my/my_contant_us.dart';
import 'package:zgene/pages/my/my_info_page.dart';
import 'package:zgene/pages/my/my_message_list.dart';
import 'package:zgene/pages/my/my_order_list.dart';
import 'package:zgene/pages/my/my_order_local.dart';
import 'package:zgene/pages/my/my_report_page.dart';
import 'package:zgene/pages/my/my_set.dart';
import 'package:zgene/pages/my/sendBack_acquisition.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/login_base.dart';
import 'package:zgene/util/notification_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:zgene/widget/base_web.dart';

class MyPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _MyPageState();
  }
}

class _MyPageState extends BaseWidgetState<MyPage> {
  final eventBus = CommonUtils.getInstance();
  int count = 0;

  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = false;
    // isShowBack = false;
    getHttp();
    setWantKeepAlive = true;
    backImgPath = "assets/images/mine/img_bg_my.png";
    NotificationCenter.instance.addObserver(NotificationName.GetUserInfo,
        (object) {
      print("123123123123123123123123");
      if (object == null) {
        getHttp();
      }
      setData();
    });

    bus.on(CommonConstant.refreshMine, (event) {
      getHttp();
    });

    HomeGetHttp(18, (result) {
      ContentModel contentModel = ContentModel.fromJson(result);
      if (contentModel.archives.length > 0) {
        bannerImg = contentModel.archives[0].imageUrl;
        bannerUrl = (contentModel.archives[0].id).toString();
        bannerTitle = contentModel.archives[0].title;
      } else {
        bannerImg = "";
        bannerUrl = "";
        bannerTitle = "";
      }
      setState(() {});
    });

    eventBus.on<selectMineEvent>().listen((event) {
      getNoticeCount();
    });
  }

  var spUtils = SpUtils();
  String avatarImg = "";
  String userName = "";
  String bannerImg = "";
  String bannerUrl = "";
  String bannerTitle = "";

  UserInfoModel userInfo = UserInfoModel();

  getHttp() {
    // EasyLoading.show(status: 'loading...');
    // Map<String, dynamic> map = new HashMap();
    HttpUtils.requestHttp(
      ApiConstant.userInfo,
      // parameters: map,
      method: HttpUtils.GET,
      onSuccess: (data) {
        print(data);
        EasyLoading.dismiss();
        UserInfoModel userInfoModel = UserInfoModel.fromJson(data);
        userInfo = userInfoModel;

        spUtils.setStorage(SpConstant.UserName, userInfo.nickname);
        spUtils.setStorage(SpConstant.UserAvatar, userInfo.avatar);
        spUtils.setStorage(SpConstant.UserMobile, userInfo.mobile);
        spUtils.setStorage(SpConstant.isBindWx, userInfo.bindWx);

        setData();
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
        setData();
        print(error);
      },
    );
  }

  getNoticeCount() {
    // EasyLoading.show(status: 'loading...');
    // Map<String, dynamic> map = new HashMap();
    HttpUtils.requestHttp(
      ApiConstant.userNoticeCount,
      // parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) {
        if (result != null) {
          setState(() {
            count = result;
          });
          print(result);
        }
      },
      onError: (code, error) {
        print(error);
      },
    );
  }

  setData() {
    userName = spUtils.getStorageDefault(SpConstant.UserName, "").toString();
    avatarImg = spUtils.getStorageDefault(SpConstant.UserAvatar, "").toString();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    NotificationCenter.instance
        .removeNotification(NotificationName.GetUserInfo);
    eventBus.destroy();
    bus.off(CommonConstant.refreshMine);
  }

// assets/images/mine/img_bg_my.png
  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage("assets/images/mine/img_bg_my.png"),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _onTapEvent(1);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 45, 0, 0),
              child: Stack(children: [
                Image(
                  image: AssetImage("assets/images/mine/icon_my_message.png"),
                  height: 42,
                  width: 42,
                ),
                Positioned(
                    right: 6,
                    top: 6,
                    child: Offstage(
                      offstage: !(count > 0),
                      child: Container(
                        width: 16,
                        height: 16,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0XFFF72937),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          count > 0 ? count.toString() : "",
                          style: TextStyle(
                            fontSize: 11,
                            color: ColorConstant.WhiteColor,
                          ),
                        ),
                      ),
                    )),
              ]),
              alignment: Alignment.topRight,
            ),
          ),
          _getMyInfo(),
          Visibility(
            visible: bannerImg == "" ? false : true,
            child: InkWell(
              onTap: () {
                var link = ApiConstant.getH5DetailUrl(bannerUrl);
                print(link);
                NavigatorUtil.push(
                    context,
                    BaseWebView(
                      url: link,
                      title: bannerTitle,
                    ));
              },
              child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/mine/icon_default_banner.png',
                      image: CommonUtils.splicingUrl(bannerImg),
                      height: 80,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      fadeInDuration: TimeUtils.fadeInDuration(),
                      fadeOutDuration: TimeUtils.fadeOutDuration(),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/mine/icon_default_banner.png",
                          height: 80,
                          width: double.infinity,
                        );
                      })),
            ),
          ),
          MyoRderNav(),
          _getProductPurchase(),
          _getSet(),
        ],
      ),
    );
  }

  ///个人信息
  _getMyInfo() {
    return GestureDetector(
      onTap: () {
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
                //   Container(
                //     margin: EdgeInsets.only(right: 14),
                //     child: Image(
                //       image: AssetImage("assets/images/mine/img_my_avatar.png"),
                //       height: 66,
                //       width: 66,
                //     ),
                //   ),
                Container(
                  margin: EdgeInsets.only(right: 14),
                  child: ClipOval(
                    child: avatarImg == ""
                        ? Image.asset(
                            'assets/images/mine/img_my_avatar.png',
                            height: 66,
                            width: 66,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'assets/images/mine/img_my_avatar.png',
                            image: CommonUtils.splicingUrl(avatarImg),
                            width: 66,
                            height: 66,
                            fit: BoxFit.cover,
                            fadeInDuration: TimeUtils.fadeInDuration(),
                            fadeOutDuration: TimeUtils.fadeOutDuration(),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/mine/img_my_avatar.png",
                                height: 66,
                                width: 66,
                              );
                            }),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName == "" ? "登录/注册" : userName,
                      style: TextStyle(
                        fontSize: 28,
                        color: ColorConstant.TextMainBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      spUtils.getStorageDefault(SpConstant.IsLogin, false)
                          ? "欢迎来到Z基因研究中心"
                          : "Z基因帮你解锁出厂设置",
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
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
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
            child: GestureDetector(
              onTap: () {
                _onTapEvent(3);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image:
                        AssetImage("assets/images/mine/icon_wodedingdan.png"),
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
            right: 0,
            child: GestureDetector(
              onTap: () {
                _onTapEvent(5);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image:
                        AssetImage("assets/images/mine/icon_yueduzhinan.png"),
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
                      "产品购买",
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
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
                      "我的报告",
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
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
            onTap: () {
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
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
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
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
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
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
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
                      style: TextStyle(fontSize: 15, color: Color(0xFF112950)),
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
  _onTapEvent(index) async {
    switch (index) {
      case 1: //消息
        NavigatorUtil.push(context, MyMessagePage());
        break;
      case 2: //个人信息
        // NavigatorUtil.push(context, MyInfoPage());
        if (userInfo.id != null) {
          if (spUtils.getStorageDefault(SpConstant.IsLogin, false)) {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyInfoPage(userInfo: userInfo)));
            if (result != null) {
              userInfo = result;
              setData();
            }
          } else {
            BaseLogin.login();
          }
        } else {
          EasyLoading.showError("个人信息获取失败，请稍后再试。");
          getHttp();
        }
        break;
      case 3: //我的订单
        NavigatorUtil.push(context, MyOrderListPage());
        break;
      case 4: //绑定采集器
        NavigatorUtil.push(context, BindCollectorPage());
        break;
      case 5: //回寄采集器

        NavigatorUtil.push(context, SendBackAcquisitionPage());

        break;
      case 6: //产品购买
        UiUitls.showToast("产品购买");
        break;
      case 7: //我的报告
        NavigatorUtil.push(context, MyReportPage());
        break;
      case 8: //设置
        NavigatorUtil.push(context, MySetPage());
        break;
      case 9: //联系客服
        NavigatorUtil.push(context, contantUsPage());
        break;
      case 10: //常见问题
        NavigatorUtil.push(context, CommonQusListPage());
        break;
      case 11: //关于Z基因
        // NavigatorUtil.push(context, AboutZPage());
        BaseLogin.login();
        break;
    }
  }
}
