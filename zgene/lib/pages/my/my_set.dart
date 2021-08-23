import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/userInfo_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/cache_manager.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:launch_review/launch_review.dart';
import 'package:zgene/widget/base_web.dart';
import 'my_about_divms.dart';
import 'my_contact_us.dart';
import 'my_information.dart';

////设置页面
class mySet extends StatefulWidget {
  UserInfoModel userInfo = UserInfoModel();
  mySet({Key key, this.userInfo}) : super(key: key);

  @override
  _mySetState createState() => _mySetState();
}

class _mySetState extends State<mySet> {
  @override
  void initState() {
    super.initState();
    initCache();
  }

  var spUtils = SpUtils();

  var buildList = [
    {'title': "编辑资料", 'text': ""},
    {'title': "清除缓存", 'text': ""},
    {'title': "隐私政策", 'text': ""},
    {'title': "用户协议", 'text': ""},
    {'title': "关于「" + SpConstant.AppName + "」", 'text': ""},
    {'title': "联系我们", 'text': ""},
    // {'title': "推荐给朋友", 'text': ""},
    {'title': "去评分", 'text': ""},
    {'title': "退出登录", 'text': ""},
  ];

  var logOutbuildList = [
    {'title': "清除缓存", 'text': ""},
    {'title': "隐私政策", 'text': ""},
    {'title': "用户协议", 'text': ""},
    {'title': "关于「" + SpConstant.AppName + "」", 'text': ""},
    {'title': "联系我们", 'text': ""},
    // {'title': "推荐给朋友", 'text': ""},
    {'title': "去评分", 'text': ""},
  ];

  // var _cacheSizeStr = "0M";

  @override
  Widget build(BuildContext context) {
    // _cacheSizeStr = widget.cacheSizeStr;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.WhiteColor,
        brightness: Brightness.light,
        // iconTheme: IconThemeData(
        //   color: ColorConstant.MainBlack, //修改颜色
        //   size: 16,
        // ),
        leading: IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/mine/icon_mine_backArrow.png"),
            size: 16,
            color: ColorConstant.MainBlack,
          ),
          onPressed: () {
            Navigator.pop(context, widget.userInfo);
          },
        ),
        elevation: 0,
        title: Text(
          "设置",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: ColorConstant.MainBlack),
        ),
      ),
      body: Container(
        color: ColorConstant.BgColor,
        child: ListView.separated(

            // ignore: missing_return
            itemBuilder: (context, indexs) {
              var _height = 59.0;

              switch (spUtils.getStorageDefault(SpConstant.IsLogin, false)) {
                case true:
                  if (indexs == 0 || indexs == 1 || indexs == 5) {
                    _height = 67.0;
                  }
                  if (indexs == 7) {
                    return loginOutlistCell(buildList[indexs], indexs);
                  } else {
                    return mainlistCell(buildList[indexs], indexs, _height);
                  }
                  break;
                case false:
                  if (indexs == 0 || indexs == 4) {
                    _height = 67.0;
                  }
                  return mainlistCell(logOutbuildList[indexs], indexs, _height);
                  break;
                default:
                  if (indexs == 0 || indexs == 1 || indexs == 5) {
                    _height = 67.0;
                  }
                  if (indexs == 7) {
                    return loginOutlistCell(buildList[indexs], indexs);
                  } else {
                    return mainlistCell(buildList[indexs], indexs, _height);
                  }
                  break;
              }
            },
            separatorBuilder: (context, index) {
              return Divider(
                indent: 15,
                endIndent: 15,
                height: 1,
                color: ColorConstant.LineMainColor,
              );
            },
            itemCount: spUtils.getStorageDefault(SpConstant.IsLogin, false)
                ? buildList.length
                : logOutbuildList.length),
      ),
    );
  }

  Widget mainlistCell(Map data, int index, double height) {
    var _height = height;

    return GestureDetector(
      onTap: () {
        if (spUtils.getStorageDefault(SpConstant.IsLogin, false)) {
          didListAction(index);
        } else {
          didListAction(index + 1);
        }
      },
      child: Container(
        height: _height,
        color: ColorConstant.WhiteColor,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: _height == 59.0 ? 0 : 8,
                color: ColorConstant.BgColor,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 18, left: 15, bottom: 18),
                    // height: 25,
                    child: Text(
                      data['title'],
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
                  Expanded(child: Container()),
                  ValueListenableBuilder(
                    valueListenable: cacheSize,
                    builder:
                        (BuildContext context, dynamic value, Widget child) {
                      return Container(
                        margin: EdgeInsets.only(top: 18, right: 14, bottom: 18),
                        child: Text(
                          spUtils.getStorageDefault(SpConstant.IsLogin, false)
                              ? index == 1
                                  ? value
                                  : ""
                              : index == 0
                                  ? value
                                  : "",
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.TextMainColor,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      right: 15,
                      // top: 24,
                      // bottom: 24,
                    ),
                    child: Image(
                      width: 12,
                      height: 12,
                      image: AssetImage(
                          "assets/images/mine/icon_mine_listArrow.png"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginOutlistCell(Map data, int index) {
    var _height = 67.0;
    return GestureDetector(
      onTap: () {
        didListAction(index);
      },
      child: Container(
        height: _height,
        color: ColorConstant.WhiteColor,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: _height == 59.0 ? 0 : 8,
                color: ColorConstant.BgColor,
              ),
              Container(
                margin: EdgeInsets.only(top: 18, left: 15, bottom: 18),
                // height: 25,
                child: Text(
                  data['title'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    color: Color(CommonConstant.THEME_COLOR),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> didListAction(int index) async {
    switch (index) {
      case 0:
        if (widget.userInfo.id != null) {
          final result = await NavigatorUtil.push(context, MyInformation(userInfo: widget.userInfo));

          if (result != null) {
            widget.userInfo = result;
          }
        } else {
          EasyLoading.showError("个人信息获取失败，请返回上一页重试");
        }

        break;
      case 1:
        didCleanCache();
        break;
      case 2:
        NavigatorUtil.push(context, BaseWebView(
          url: ApiConstant.privacys,
          title: "隐私政策",
        ));

        break;
      case 3:
        NavigatorUtil.push(context, BaseWebView(
          url: ApiConstant.agreements,
          title: "用户协议",
        ));

        break;
      case 4:
        NavigatorUtil.push(context, myAboutDivms());

        break;
      case 5:
        NavigatorUtil.push(context, myContactUs());

        break;
      case 6:
        LaunchReview.launch(
          androidAppId: CommonConstant.AndroidAppId,
          iOSAppId: CommonConstant.iOSAppId,
        );
        break;
      case 7:
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('退出登录'),
                  content: Text(('确认退出登录？')),
                  actions: <Widget>[
                    new TextButton(
                      child: Text("取消",
                          style: TextStyle(
                            // fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.TextMainGray,
                          )),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new TextButton(
                      child: Text("确定",
                          style: TextStyle(
                            // fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: Color(CommonConstant.THEME_COLOR),
                          )),
                      onPressed: () {
                        //清除登录信息
                        spUtils.setStorage(SpConstant.Token, "");
                        spUtils.setStorage(SpConstant.IsLogin, false);
                        spUtils.setStorage(SpConstant.Uid, 0);
                        HttpUtils.clear();
                        //清除用户信息
                        spUtils.setStorage(SpConstant.UserName, "");
                        spUtils.setStorage(SpConstant.UserAvatar, "");
                        spUtils.setStorage(SpConstant.UserCoins, 0);
                        EasyLoading.showSuccess('退出登录成功');
                        Navigator.of(context).pop();
                        Navigator.pop(context, widget.userInfo);
                      },
                    ),
                  ],
                ));
        break;
      default:
    }
  }

  ValueNotifier<String> cacheSize = ValueNotifier("0M");

  Future<void> initCache() async {
    var size = await CacheUtil.loadCache();
    cacheSize.value = size ?? "";
  }

  Future<void> handleClearCache() async {
    /// 执行清除缓存
    await CacheUtil.clear();

    /// 更新缓存
    await initCache();
    Fluttertoast.showToast(
        msg: "清理成功",
        gravity: ToastGravity.CENTER,
        backgroundColor: ColorConstant.LineMainColor,
        textColor: ColorConstant.TextMainColor);
  }

  didCleanCache() {
    if (cacheSize.value == "0M") {
      Fluttertoast.showToast(
          msg: "暂无缓存可清理",
          gravity: ToastGravity.CENTER,
          backgroundColor: ColorConstant.LineMainColor,
          textColor: ColorConstant.TextMainColor);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('您有' + cacheSize.value + '缓存'),
                content: Text(('是否确定清理？')),
                actions: <Widget>[
                  new TextButton(
                    child: Text("取消",
                        style: TextStyle(
                          // fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.TextMainGray,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new TextButton(
                    child: Text("确定",
                        style: TextStyle(
                          // fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.TextMainColor,
                        )),
                    onPressed: () {
                      handleClearCache();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
  }
}
