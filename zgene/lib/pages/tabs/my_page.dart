import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:launch_review/launch_review.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/event/event_bus.dart';

import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/userInfo_model.dart';
import 'package:zgene/pages/my/my_about_divms.dart';
import 'package:zgene/pages/my/my_contact_us.dart';
import 'package:zgene/pages/my/my_information.dart';
import 'package:zgene/pages/my/my_manager_page.dart';
import 'package:zgene/pages/my/my_set.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/login_base.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/time_utils.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}


class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  @override
  var buildList = [
    {'img': "assets/images/mine/icon_mine_listHistory.png", 'text': "历史记录"},
    {
      'img': "assets/images/mine/icon_mine_listContact.png",
      'text': "关于「" + SpConstant.AppName + "」"
    },
    {'img': "assets/images/mine/icon_mine_listAbout.png", 'text': "联系我们"},
    // {'img': "assets/images/mine/icon_mine_listShare.png", 'text': "推荐给朋友"},
    {'img': "assets/images/mine/icon_mine_listScore.png", 'text': "去评分"},
  ];
  var spUtils = SpUtils();
  String avatarImg = "";
  String userName = "";
  String userCoins = "";
  @override
  void initState() {
    super.initState();
    // setData();
    getHttp();
    bus.on(EventBus.GetUserInfo,
            (object) {
          if (object != null) {
            setData();
          } else {
            getHttp();
          }
        });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    print("注销了");
    bus.off(EventBus.GetUserInfo);
  }

  setData() {
    print("来了");
    userName = spUtils.getStorageDefault(SpConstant.UserName, "").toString();
    avatarImg = spUtils.getStorageDefault(SpConstant.UserAvatar, "").toString();
    userCoins = spUtils.getStorageDefault(SpConstant.UserCoins, 0).toString();
    setState(() {});
  }

  // Map<String, dynamic> userInfo = {};.
  UserInfoModel userInfo = UserInfoModel();

  getHttp() {
    // EasyLoading.show(status: 'loading...');
    // Map<String, dynamic> map = new HashMap();
    HttpUtils.requestHttp(
      ApiConstant.userInfo,
      // parameters: map,
      method: HttpUtils.GET,
      onSuccess: (data) {
        EasyLoading.dismiss();
        UserInfoModel userInfoModel = UserInfoModel.fromJson(data);
        userInfo = userInfoModel;

        spUtils.setStorage(SpConstant.UserName, userInfo.nickname);
        spUtils.setStorage(SpConstant.UserAvatar, userInfo.avatar);
        spUtils.setStorage(SpConstant.UserCoins, userInfo.coin);
        setData();
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
        print(error);
      },
    );
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: listHeaderView(context),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(height: 425, child: listHeaderView(context)),
          ),
          SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate(buildListItem,
                  childCount: buildList.length),
              itemExtent: 58)
        ],
      ),
    );
  }

//顶部总视图
  Widget listHeaderView(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(top: 0, left: 0, right: 0, child: topInfoView(context)),
            Positioned(
                top: 89,
                left: 0,
                right: 0,
                child: Container(
                  height: 69,
                  child: GestureDetector(
                    onTap: () {
                      infoClick(context);
                    },
                  ),
                )),
            Positioned(
                top: 186,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    coinsInfoView(context),
                    functionListView(context),
                    Container(
                      margin: EdgeInsets.only(
                        left: 26,
                        bottom: 20,
                      ),
                      child: Text(
                        "更多功能",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.TextMainColor,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }

//个人资料视图
  Widget topInfoView(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      // color: Color(CommonConstant.THEME_COLOR),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            colors: [
              Color(CommonConstant.THEME_COLOR_GRADIENT_START),
              Color(CommonConstant.THEME_COLOR)
            ],

            // THEME_COLOR_GRADIENT_START
          )),
      child: Container(
        // padding: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 89, 15, 64),
              child: ClipOval(
                child: avatarImg == ""?
                     Image.asset(
                  'assets/images/home/img_default_avatar.png',
                  height: 69,
                  width: 69,
                )
                    : FadeInImage.assetNetwork(
                    placeholder:
                    'assets/images/home/img_default_avatar.png',
                    image: CommonUtils.splicingUrl(avatarImg),
                    width: 69,
                    height: 69,
                    fit: BoxFit.cover,
                    fadeInDuration: TimeUtils.fadeInDuration(),
                    fadeOutDuration: TimeUtils.fadeOutDuration(),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/home/img_default_avatar.png",
                        height: 69,
                        width: 69,
                      );
                    }),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 101, 0, 0),
              width: MediaQuery.of(context).size.width - 135,
              // padding: EdgeInsets.only(
              //   right: 10,
              // ),
              // padding: EdgeInsets.all(0),
              // margin: EdgeInsets.fromLTRB(left, top, right, bottom),
              // color: Colors.red[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userName != "" ? userName : "未登录",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.WhiteColor,
                    ),
                  ),
                  Text(
                    "查看或编辑个人资料",
                    textAlign: TextAlign.left,
                    maxLines: 10,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.WhiteColor7F,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: 15,
                    top: 48,
                    left: 0,
                  ),
                  width: 23,
                  height: 23,
                  // color: Colors.red[200],
                  child: Center(
                    child: IconButton(
                      // iconSize: 23,
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        setClick(context);
                      },
                      // icon: Icon(Icons.settings_outlined),
                      icon: ImageIcon(
                        AssetImage("assets/images/mine/icon_mine_Setting.png"),
                        size: 23,
                        color: ColorConstant.WhiteColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 26,
                    top: 46,
                    left: 0,
                  ),
                  width: 15,
                  height: 15,
                  // color: Colors.red[200],
                  child: Center(
                    child: IconButton(
                      // iconSize: 23,
                      padding: EdgeInsets.all(0),
                      onPressed: null,
                      // icon: Icon(Icons.settings_outlined),
                      icon: ImageIcon(
                        AssetImage("assets/images/mine/icon_main_goArrow.png"),
                        size: 15,
                        color: ColorConstant.WhiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

//金币充值视图
  Widget coinsInfoView(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/mine/icon_mine_coinsBg.png"))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 17,
              left: 21,
              bottom: 17,
            ),
            child: Image(
              image: AssetImage("assets/images/mine/icon_mine_coin.png"),
              width: 21,
              height: 21,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 10,
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 222,
                        minWidth: 0),
                    child: Text(
                      userCoins != "" ? userCoins : "0",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.WhiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 4,
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "金币数量(个）",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.WhiteColor7F,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            margin: EdgeInsets.only(
              right: 14,
              top: 13,
              bottom: 13,
            ),
            width: 79,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        "assets/images/mine/icon_mine_topUpBg.png"))),
            child: TextButton(
                onPressed: () {
                  coinsClick(context);
                },
                child: Center(
                  child: Text(
                    "立即充值",
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.TextMainColor,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

//功能区视图
  Widget functionListView(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(31, 25, 31, 30),
        height: 139,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            functionButton(context, 0,
                "assets/images/mine/icon_mine_myCollect.png", "我的收藏"),
            functionButton(
                context, 1, "assets/images/mine/icon_mine_mylike.png", "我的点赞"),
            functionButton(context, 2,
                "assets/images/mine/icon_mine_myComment.png", "我的评论"),
            functionButton(context, 3,
                "assets/images/mine/icon_mine_myHistory.png", "消费历史"),
          ],
        ));
  }

  Widget functionButton(
      BuildContext context, int index, String img, String text) {
    return GestureDetector(
      onTap: () {
        didFunctionAction(index);
      },
      child: Container(
        child: Column(
          children: [
            Image(
              image: AssetImage(img),
              width: 55,
              height: 55,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: ColorConstant.TextMainColor,
              ),
            )
          ],
        ),
      ),
    );
  }

//更多功能列表视图
  Widget buildListItem(BuildContext context, int index) {
    return TextButton(
      onPressed: () {
        didBuildListAction(index);
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      child: Column(
        children: [
          Container(
            height: 57.5,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 21,
                    left: 24,
                    bottom: 21,
                  ),
                  child: Image(
                    image: AssetImage(buildList[index]['img']??""),
                    // width: 21,
                    // height: 21,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 9),
                  child: Center(
                    child: Text(
                      buildList[index]['text']??"",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.TextMainColor,
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(
                    right: 24,
                    top: 24,
                    bottom: 24,
                  ),
                  child: Image(
                    image: AssetImage(
                        "assets/images/mine/icon_mine_listArrow.png"),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 0),
            height: 0.5,
            color: ColorConstant.LineMainColor,
          )
        ],
      ),
    );
  }

//点击事件
//跳转个人资料
  infoClick(BuildContext context) async {
    if (userInfo.id != null) {
      if (spUtils.getStorageDefault(SpConstant.IsLogin, false)) {
        final result = await NavigatorUtil.push(context, MyInformation(userInfo: userInfo));

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
  }

//跳转金币详情。
  coinsClick(BuildContext context) async {
    if (spUtils.getStorageDefault(SpConstant.IsLogin, false)) {
      // final result = await Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => MyCoins()));
      // if (result != null) {
      //   getHttp();
      // }
    } else {
      BaseLogin.login();
    }
  }

//跳转设置详情
  setClick(BuildContext context) async {
    // NavigatorUtils.push(context, RouterPath.mySet);
    final result = await NavigatorUtil.push(context, mySet(userInfo: userInfo));

    if (result != null) {
      userInfo = result;
      setData();
      // setState(() {});
    }
  }

//跳转更多功能列表
  didBuildListAction(int index) {
    Map<String, dynamic> map = new HashMap();
    switch (index) {
      case 0: //历史记录
        map["index"] = 0;
        NavigatorUtil.push(context, MyManagerPage(map));
        break;
      case 1:
        NavigatorUtil.push(context, myAboutDivms());

        break;
      case 2:
        NavigatorUtil.push(context, myContactUs());

        break;
      case 3:
        LaunchReview.launch(
          androidAppId: CommonConstant.AndroidAppId,
          iOSAppId: CommonConstant.iOSAppId,
        );
        break;
      default:
    }
  }

  //功能区跳转
  didFunctionAction(int index) {
    Map<String, dynamic> map = new HashMap();
    switch (index) {
      case 0: //收藏
        map["index"] = 1;
        NavigatorUtil.push(context, MyManagerPage(map));
        break;
      case 1: //点赞
        map["index"] = 2;
        NavigatorUtil.push(context, MyManagerPage(map));
        break;
      case 2: //评论
        map["index"] = 3;
        NavigatorUtil.push(context, MyManagerPage(map));
        break;
      case 3: //消费
        map["index"] = 4;
        NavigatorUtil.push(context, MyManagerPage(map));
        break;
      default:
    }
  }
}