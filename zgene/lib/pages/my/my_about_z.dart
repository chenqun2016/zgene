import 'package:base/util/sp_utils.dart';
import 'package:base/widget/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launch_review/launch_review.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/config_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/my/my_about_us.dart';
import 'package:zgene/widget/base_web.dart';

class AboutZPage extends StatefulWidget {
  @override
  BaseWidgetState createState() {
    return _AboutZPageState();
  }
}

class _AboutZPageState extends BaseWidgetState<AboutZPage> {
  @override
  void customInitState() {
    super.customInitState();
    showHead = true;
    backImgPath = "assets/images/mine/icon_about_us_back.png";
    pageWidgetTitle = "关于Z基因";
    textStyle = TextStyle(
      fontSize: 16.sp,
      color: Color(0xFF112950),
      fontWeight: FontWeight.w500,
    );
//
    if (SpUtils().getStorageDefault(SpConstant.appLatestVersion, "") ==
        CommonConstant.AppVer) {
      isNew = false;
    } else {
      isNew = true;
    }
  }

  var textStyle;
  var isNew = true;

  @override
  Widget customBuildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      width: double.infinity,
      height: MediaQuery.of(context).size.height - 100.h,
      child: Stack(
        children: [
          Column(
            children: [
              operationView(),
            ],
          ),
        ],
      ),
    );
  }

  Widget operationView() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10.h, 16, 10.h),
      margin: EdgeInsets.fromLTRB(15, 5, 15, 8),
      width: double.infinity,
      decoration: new BoxDecoration(
        color: ColorConstant.WhiteColorB2,
        borderRadius: BorderRadius.all(Radius.circular(20.h)),
        //设置四周边框
        border: new Border.all(width: 1, color: ColorConstant.WhiteColor),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 0.h, left: 92.w, right: 92.w),
                child: Image(
                  image: AssetImage("assets/images/mine/icon_aboutUs_top.png"),
                  height: 160.h,
                  // width: 97.w,
                ),
              ),
              Positioned(
                  child: Container(
                margin: EdgeInsets.only(top: 139.h, left: 119.w, right: 119.w),
                child: Image(
                  image: AssetImage("assets/images/mine/icon_Zgene_icon.png"),
                  height: 28.h,
                  // width: 97.w,
                ),
              ))
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 39.h),
            child: GestureDetector(
              onTap: () {
                _onTapEvent(0);
              },
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Z基因官网",
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
          ),
          GestureDetector(
            onTap: () {
              _onTapEvent(1);
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "关于我们",
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
                      "检测更新",
                      style: textStyle,
                    )),
                Positioned(
                  right: 0,
                  top: 15,
                  child: Row(
                    children: [
                      Offstage(
                        offstage: !isNew,
                        child: Container(
                          margin: EdgeInsets.only(right: 6.w),
                          child: Text(
                            "●",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.MainRed,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8.w),
                        child: Text(
                          "版本号：V" + CommonConstant.AppVer,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: isNew
                                ? ColorConstant.MainBlueColor
                                : ColorConstant.Text_5E6F88,
                          ),
                        ),
                      ),
                      Image(
                        image:
                            AssetImage("assets/images/mine/icon_my_right.png"),
                        height: 16,
                        width: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onTapEvent(index) {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BaseWebView(
                      url: CommonConstant.BASE_API,
                      title: "Z基因官网",
                    )));
        break;
      case 1:
        NavigatorUtil.push(context, AboutUsPage());
        break;
      case 2:
        if (isNew) {
          LaunchReview.launch(
            androidAppId: ConfigConstant.AndroidAppId,
            iOSAppId: ConfigConstant.iOSAppId,
          );
        } else {
          EasyLoading.showSuccess("当前就是最新版本哦~");
        }

        break;
    }
  }
}
