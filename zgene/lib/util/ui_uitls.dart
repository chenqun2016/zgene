import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/util/platform_utils.dart';
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
    Fluttertoast.showToast(
        msg: name,
        gravity: ToastGravity.CENTER,
        backgroundColor: ColorConstant.LineMainColor,
        textColor: ColorConstant.TextMainColor);
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
      case 1: //暂无数据
        imageUrl = "assets/images/img_no_data.png";
        if (text == null) {
          title = "暂无内容";
        } else {
          title = text;
        }
        break;
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

  ///显示协议
  static showAgreement(context, {onAgree, onCancel}) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Center(
            child: Material(
              child: Container(
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width * .8,
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        '用户协议和隐私政策',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: PrivacyView(
                          data: CommonConstant.Privacy_Text,
                          keys: ['《用户协议》', '《隐私政策》'],
                          keyStyle:
                              TextStyle(color: ColorConstant.TextMainColor),
                          onTapCallback: (String key) {
                            if (key == '《用户协议》') {
                              NavigatorUtil.push(
                                  context,
                                  BaseWebView(
                                    url: ApiConstant.agreements,
                                    title: "用户协议",
                                  ));
                            } else if (key == '《隐私政策》') {
                              NavigatorUtil.push(
                                  context,
                                  BaseWebView(
                                    url: ApiConstant.privacys,
                                    title: "隐私政策",
                                  ));
                            }
                          },
                        ),
                      ),
                    )),
                    Divider(
                      height: 1,
                    ),
                    Container(
                      height: 45,
                      child: Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text('不同意')),
                            onTap: () {
                              Navigator.of(context).pop();
                              onCancel();
                            },
                          )),
                          VerticalDivider(
                            width: 1,
                          ),
                          Expanded(
                              child: GestureDetector(
                            child: Container(
                                alignment: Alignment.center,
                                color: Color(CommonConstant.THEME_COLOR),
                                child: Text(
                                  '同意',
                                  style: TextStyle(
                                      color: ColorConstant.WhiteColor),
                                )),
                            onTap: () {
                              Navigator.of(context).pop();
                              onAgree();
                            },
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
