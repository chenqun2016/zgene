import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/login/change_Password.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/sp_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

import 'my_address_list.dart';

class AboutUsPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _AboutUsPageState();
  }
}

class _AboutUsPageState extends BaseWidgetState<AboutUsPage> {
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = true;
    backImgPath = "assets/images/mine/icon_about_us_back.png";
    pageWidgetTitle = "关于我们";
    textStyle = TextStyle(
      fontSize: 16.sp,
      color: Color(0xFF112950),
      fontWeight: FontWeight.w500,
    );
  }

  var textStyle;
  var isNew = true;

  @override
  Widget viewPageBody(BuildContext context) {
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
          Positioned(
            bottom: 29.h,
            left: 16.w,
            right: 16.w,
            // height: 55,
            child: Text(
              "上海晓得基因科技有限公司",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 15.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: ColorConstant.Text_5E6F88,
              ),
            ),
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
              )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 25.h, bottom: 32.h),
            child: Text(
              SpUtils().getStorageDefault(SpConstant.appAboutusDescription, ""),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 15.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: ColorConstant.TextSecondColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  _onTapEvent(index) {
    switch (index) {
      case 0:
        Clipboard.setData(
            ClipboardData(text: CommonConstant.App_Contact_Wx_Code));
        EasyLoading.showSuccess('客服（QQ）复制成功');
        break;
      case 1:
        break;
    }
  }
}
