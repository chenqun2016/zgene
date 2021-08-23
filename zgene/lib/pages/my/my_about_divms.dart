
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:launch_review/launch_review.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/event/event_bus.dart';

import 'package:zgene/http/http_utils.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/time_utils.dart';

import 'my_contact_us.dart';

////关于我们
class myAboutDivms extends StatefulWidget {
  myAboutDivms({Key key}) : super(key: key);

  @override
  _myAboutDivmsState createState() => _myAboutDivmsState();
}

class _myAboutDivmsState extends State<myAboutDivms> {
  @override
  var buildList = [
    {'title': "当前版本", 'text': "V1.0"},
    {'title': "联系我们", 'text': ""},
    {'title': "去评分", 'text': ""},
    {'title': "注销账号", 'text': ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.WhiteColor,
        brightness: Brightness.light,
        leading: IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/mine/icon_mine_backArrow.png"),
            size: 16,
            color: ColorConstant.MainBlack,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: Text(
          "关于" + SpConstant.AppName,
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
        child: Column(
          children: [
            Container(
              height: 197,
              width: double.infinity,
              padding: EdgeInsets.all(55),
              child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/home/img_default2.png',
                  image:
                      CommonUtils.splicingUrl(CommonConstant.App_Logo_Banner),
                  // width: 69,
                  // height: 69,
                  fit: BoxFit.fitHeight,
                  fadeInDuration: TimeUtils.fadeInDuration(),
                  fadeOutDuration: TimeUtils.fadeOutDuration(),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/mine/icon_WechatQrCode.png",
                      // height: 69,
                      // width: 69,
                    );
                  }),
            ),
            Container(
              height: 59.0 * buildList.length,
              color: ColorConstant.BgColor,
              child: ListView.separated(
                  itemBuilder: (context, indexs) {
                    return mainlistCell(buildList[indexs], indexs);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      indent: 15,
                      endIndent: 15,
                      height: 1,
                      color: ColorConstant.LineMainColor,
                    );
                  },
                  itemCount: buildList.length),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainlistCell(Map data, int index) {
    return GestureDetector(
      onTap: () {
        didListAction(index);
      },
      child: Container(
        height: 59.0,
        color: ColorConstant.WhiteColor,
        child: Center(
          child: Row(
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
                    color: index == 3
                        ? ColorConstant.TextSecondColor
                        : ColorConstant.TextMainColor,
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(top: 18, right: 14, bottom: 18),
                child: Text(
                  data['text'],
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.TextMainColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  right: index == 0 ? 0 : 15,
                  // top: 24,
                  // bottom: 24,
                ),
                child: Image(
                  width: index == 0 ? 0 : 12,
                  height: index == 0 ? 0 : 12,
                  image:
                      AssetImage("assets/images/mine/icon_mine_listArrow.png"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget didListAction(int index) {
    switch (index) {
      case 1:
        NavigatorUtil.push(context, myContactUs());

        break;
      case 2:
        LaunchReview.launch(
          androidAppId: CommonConstant.AndroidAppId,
          iOSAppId: CommonConstant.iOSAppId,
        );
        break;
      case 3:
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('注销账号'),
                  content: Text(
                      ('请您确认是否注销该账号：您的账户在注销时如有剩余金币、未使用完毕的虚拟物品等增值服务的，建议您先将其使用/消耗完毕，否则一旦您点击下方【确定】按钮，将视为您自愿放弃您在账号内购买的金币、虚拟物品等增值服务的所有权，并同意平台将其全部清空且无法恢复。注销完成后，系统将删除您的个人信息、使用痕迹、历史收藏、虚拟金币等，请您慎重考虑。')),
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
                        writeOffAccount();
                        // Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
        break;
      default:
    }
  }

  Future<void> writeOffAccount() async {
    EasyLoading.show(status: 'loading...');

    HttpUtils.requestHttp(
      ApiConstant.user_unregister,
      // parameters: map,
      method: HttpUtils.GET,
      onSuccess: (data) async {
        var spUtils = SpUtils();
        //清除登录信息
        spUtils.setStorage(SpConstant.Token, "");
        spUtils.setStorage(SpConstant.IsLogin, false);
        spUtils.setStorage(SpConstant.Uid, 0);
        HttpUtils.clear();
        //清除用户信息
        spUtils.setStorage(SpConstant.UserName, "");
        spUtils.setStorage(SpConstant.UserAvatar, "");
        spUtils.setStorage(SpConstant.UserCoins, 0);
        EasyLoading.showSuccess('注销成功');

        HttpUtils.clear();
        bus.emit(EventBus.GetUserInfo, 1);

        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
      },
    );
  }
}
