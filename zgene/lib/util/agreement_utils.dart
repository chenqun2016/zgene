import 'package:base/constant/color_constant.dart';
import 'package:base/navigator/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/widget/base_web.dart';
import 'package:zgene/widget/privacy_view.dart';

class AgreementUtils {
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
                                        ZgeneWebView(
                                          url: CommonConstant.agreement,
                                          title: "用户协议",
                                        ));
                                  } else if (key == '《个人信息保护政策》') {
                                    NavigatorUtil.push(
                                        context,
                                        ZgeneWebView(
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
}
