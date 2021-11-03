import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zgene/configure.dart'
    if (dart.library.html) 'package:zgene/configure_web.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/platform_utils.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/widget/base_web.dart';
import 'package:zgene/widget/privacy_view.dart';

///界面相关工具
class UiUitls {
  ///状态栏（背景透明）
  static setTransparentStatus() {
    try {
      if (PlatformUtils.isAndroid) {
        //设置Android头部的导航栏透明
        SystemUiOverlayStyle systemUiOverlayStyle =
            SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    } catch (e) {
      print(e);
    }
  }

  ///状态栏（字体白色背景透明）
  static setWhiteTextStatus() {
    try {
      if (PlatformUtils.isAndroid) {
        //设置Android头部的导航栏透明
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        );
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    } catch (e) {
      print(e);
    }
  }

  ///状态栏（字体黑色背景白色）
  static setBlackTextStatus() {
    try {
      if (PlatformUtils.isAndroid) {
        //设置Android头部的导航栏透明
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        );
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    } catch (e) {
      print(e);
    }
  }

  ///toast提示
  static showToast(String name) {
    if (PlatformUtils.isWeb) {
      webShowToast(name);
    } else {
      Fluttertoast.showToast(
          msg: name,
          fontSize: 13,
          gravity: ToastGravity.CENTER,
          backgroundColor: ColorConstant.toastBlue,
          textColor: ColorConstant.toastTextBlue);
    }
  }

  ///加载框
  static getLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 30,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
          alignment: Alignment.center,
          child: SizedBox(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(CommonConstant.THEME_COLOR),
              )),
        ),
        Text(
          "数据加载中...",
          style: TextStyle(
            fontSize: 14,
            color: ColorConstant.TextMainColor,
          ),
        )
      ],
    );
  }

  ///异常界面
  static getErrorPage({context, type, text, onClick, height}) {
    //1.暂无数据 2.错误 3.没有网络
    String imageUrl, title;
    switch (type) {
      case 2: //错误
        imageUrl = "assets/images/img_error.png";
        if (text == null) {
          title = "数据出错了，点击我再试试看";
        } else {
          title = text;
        }
        break;
      case 3: //没有网络
        imageUrl = "assets/images/img_no_net.png";
        if (text == null) {
          title = "网络出错了，点击我再试试看";
        } else {
          title = text;
        }
        break;
      default:
        imageUrl = "assets/images/img_no_data.png";
        if (text == null) {
          title = "暂无内容";
        } else {
          title = text;
        }
        break;
    }
    return GestureDetector(
      onTap: () {
        if (type != 1) {
          onClick();
        }
      },
      child: Container(
        width: double.infinity,
        height: height != 0 ? height : double.infinity,
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.only(top: 100),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image(
              image: AssetImage(imageUrl),
              height: 166,
              width: 140,
            ),
            Text(
              title,
              style: TextStyle(
                color: ColorConstant.Text_8E9AB,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      // Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image(
      //         image: AssetImage(imageUrl),
      //         height: 166,
      //         width: 141,
      //       ),
      //       Container(
      //         margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      //         child: Text(
      //           title,
      //           style: TextStyle(
      //             fontSize: 12,
      //             color: ColorConstant.TextThreeColor,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  ///板块之间的线条以
  static getLine() {
    return Divider(
      height: 1,
      color: ColorConstant.LineMainColor,
    );
  }

  static showAgreement2(context, {onAgree, onCancel}) {
    print(MediaQuery.of(context).size.height.toString());
    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: ColorConstant.AppleBlack99Color,
      backgroundColor: Colors.white,
      context: context,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Stack(
            children: [
              Image.asset(
                "assets/images/mine/img_bg_my.png",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
              Column(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(16, 2, 16, 20),
                    margin: EdgeInsets.only(top: 60, left: 16, right: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ColorConstant.WhiteColorB2,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (MediaQuery.of(context).size.height > 660)
                          Image.asset(
                            "assets/images/logo.png",
                            height: 144,
                            width: 144,
                            fit: BoxFit.fill,
                          ),
                        if (MediaQuery.of(context).size.height <= 660)
                          Divider(
                            height: 20,
                            color: Colors.transparent,
                          ),
                        Text(
                          "欢迎使用Z基因",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.TextMainBlack,
                          ),
                        ),
                        Divider(
                          height: 15,
                          color: Colors.transparent,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              PrivacyView(
                                style: TextStyle(
                                    color: ColorConstant.TextMainBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                data: CommonConstant.Privacy_Text,
                                keys: ['《用户协议》', '《个人信息保护政策》'],
                                keyStyle: TextStyle(
                                    color: ColorConstant.TextMainColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                onTapCallback: (String key) {
                                  if (key == '《用户协议》') {
                                    NavigatorUtil.push(
                                        context,
                                        BaseWebView(
                                          url: CommonConstant.agreement,
                                          title: "用户协议",
                                        ));
                                  } else if (key == '《个人信息保护政策》') {
                                    NavigatorUtil.push(
                                        context,
                                        BaseWebView(
                                          url: CommonConstant.privacy,
                                          title: "个人信息保护政策",
                                        ));
                                  }
                                },
                              ),
                              Divider(
                                height: 20,
                                color: Colors.transparent,
                              ),
                              Text(
                                CommonConstant.Privacy_Text2,
                                style: TextStyle(
                                    color: ColorConstant.Text_5E6F88,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  )),
                  Divider(
                    height: 30,
                    color: Colors.transparent,
                  ),
                  MaterialButton(
                    minWidth: 343,
                    height: 55,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    color: ColorConstant.TextMainColor,
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onAgree();
                    },
                    child: Text("同意并继续",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      onCancel();
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.fromLTRB(20, 17, 20, 17),
                      child: Text(
                        "不同意",
                        style: TextStyle(
                            color: ColorConstant.Text_5E6F88,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Divider(
                    height: 30,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  ///输入文字校验
  static List<TextInputFormatter> getInputFormatters({int max = 20}) {
    return [
      FilteringTextInputFormatter.allow(
          RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")),
      LengthLimitingTextInputFormatter(max), //最大长度
    ];
  }

//读取 assets 中的图片
  static Future<ui.Image> loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return decodeImageFromList(bytes);
  }

  ///智能语音
  ///url 拼接规则 url="对话链接(例:https://团队ID.ahc.ink/chat.html)?+"headHidden=1( 1则为隐藏title 不传则不隐藏)"+"&传递顾客参数(例如：customer={})"+"&其它参数（可选择 例如：uniqueId=会员唯一ID）"
  static void showChatH5(BuildContext context) async {
    var spUtils = SpUtils();
    var customerMap = {
      "名称": spUtils.getStorage(SpConstant.UserName).toString(),
      "手机": spUtils.getStorage(SpConstant.UserMobile).toString()
    };
    String customer = json.encode(customerMap);

    String uniqueId = spUtils.getStorage(SpConstant.AppUdid);
    if (null == uniqueId || uniqueId.isEmpty) {
      uniqueId = spUtils.getStorage(SpConstant.Uid);
    }
    String url = ApiConstant.smartServiceUrl +
        "?headHidden=1" +
        "&uniqueId=$uniqueId" +
        "&customer=$customer";

    print("url==" + url);
    NavigatorUtil.push(
        context,
        BaseWebView(
          url: url,
          title: "智能客服",
          isShare: false,
        ));
  }

  static String getAssetIcon(String color) {
    if ("green" == color) {
      return "assets/images/report/img_zhong.png";
    }
    if ("blue" == color) {
      return "assets/images/report/img_qiang.png";
    }
    if ("red" == color) {
      return "assets/images/report/img_luo.png";
    }
  }

  static String getReportDetailIndexIcon(int index) {
    switch (index % 4) {
      case 0:
        return "assets/images/report/icon_report_item_1.png";
      case 1:
        return "assets/images/report/icon_report_item_2.png";
      case 2:
        return "assets/images/report/icon_report_item_3.png";
      case 3:
        return "assets/images/report/icon_report_item_4.png";
      default:
        return "assets/images/report/icon_report_item_4.png";
    }
  }

  static String getReportListIcon(String id) {
    switch (id) {
      case "jibingshaicha":
        return "assets/images/report/banner_jibingshaicha.png";
      case "jiankangfengxian":
        return "assets/images/report/banner_jiankang.png";
      case "pifuguanli":
        return "assets/images/report/banner_pifuguanli.png";
      case "jibingshaicha":
        return "assets/images/report/banner_shenhghuozhidao.png";
      case "tizhitedian":
        return "assets/images/report/banner_tizhi.png";
      case "xinlirenzhi":
        return "assets/images/report/banner_xinlirenzhi.png";
      case "yingyangxuqiu":
        return "assets/images/report/banner_yingyangxuq.png";
      case "daixienengli":
        return "assets/images/report/banner_yinshidaixie.png";
      case "yongyaozhidao":
        return "assets/images/report/banner_yongyao.png";
      case "yundongjianshen":
        return "assets/images/report/banner_yundong.png";
      default:
        return "assets/images/report/banner_jibingshaicha.png";
    }
  }

  static getTipColor(String color) {
    if ("green" == color) {
      return LinearGradient(colors: [
        Color(0xFF47FEDB),
        Color(0xFF23CFAF),
      ]);
    }
    if ("blue" == color) {
      return LinearGradient(colors: [
        Color(0xFF5EECFD),
        Color(0xFF248DFA),
      ]);
    }
    if ("red" == color) {
      return LinearGradient(colors: [
        Color(0xFFFE8B8C),
        Color(0xFFFE4343),
      ]);
    }
  }

  static String getReportResultCircle(int color) {
    if (0 == color % 4) {
      return "assets/images/report/icon_report_item_green.png";
    }
    if (1 == color % 4) {
      return "assets/images/report/icon_report_item_blue.png";
    }
    if (2 == color % 4) {
      return "assets/images/report/icon_report_item_yellow.png";
    }
    return "assets/images/report/icon_report_item_red.png";
  }

  static String getReportResultCircle3(int color) {
    if (0 == color % 4) {
      return "assets/images/report/icon_report_item_green.png";
    }
    if (1 == color % 4) {
      return "assets/images/report/icon_report_item_blue.png";
    }
    return "assets/images/report/icon_report_item_red.png";
  }

  static Color getColor(int index) {
    if (0 == index % 4) {
      //绿色
      return ColorConstant.bg_42F5D3;
    }
    if (1 == index % 4) {
      //蓝色
      return ColorConstant.bg_017AF6;
    }
    if (2 == index % 4) {
      //黄色
      return ColorConstant.bg_FFBE00;
    }
    //橙色
    return ColorConstant.bg_FD7A7A;
  }

  static Color getColor3(int index) {
    if (0 == index % 4) {
      //绿色
      return ColorConstant.bg_42F5D3;
    }
    if (1 == index % 4) {
      //蓝色
      return ColorConstant.bg_017AF6;
    }
    //橙色
    return ColorConstant.bg_FD7A7A;
  }
}
