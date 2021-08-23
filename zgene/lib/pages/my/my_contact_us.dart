import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

////联系我们
class myContactUs extends StatefulWidget {
  myContactUs({Key key}) : super(key: key);

  @override
  _myContactUsState createState() => _myContactUsState();
}

class _myContactUsState extends State<myContactUs> {
  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: Text(
          "联系我们",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: ColorConstant.MainBlack),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 47),
              width: MediaQuery.of(context).size.width - 140,
              height: MediaQuery.of(context).size.width - 140,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: ColorConstant.WhiteColor,
                  boxShadow: [
                    BoxShadow(
                        color: ColorConstant.ArrowsShadowBlack,
                        offset: Offset(0.0, 0.0), //阴影y轴偏移量
                        blurRadius: 10, //阴影模糊程度
                        spreadRadius: 2 //阴影扩散程度
                        ),
                  ]),
              child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/home/img_default1.png',
                  image: CommonUtils.splicingUrl(
                      CommonConstant.App_Contact_Wx_Qrcode),
                  // width: 69,
                  // height: 69,
                  fit: BoxFit.cover,
                  fadeInDuration: TimeUtils.fadeInDuration(),
                  fadeOutDuration: TimeUtils.fadeOutDuration(),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/mine/icon_WechatQrCode.png",
                      height: 69,
                      width: 69,
                    );
                  }),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 84),
              height: 45,
              width: MediaQuery.of(context).size.width - 28,
              child: TextButton(
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: CommonConstant.App_Contact_Wx_Code));
                  EasyLoading.showSuccess('复制成功');
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return Color(CommonConstant.THEME_COLOR);
                    })),
                child: Text(
                  "一键复制微信号",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.WhiteColor),
                ),
              ))
        ],
      ),
    );
  }
}
