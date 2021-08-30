import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/phonetextFild_input.dart';

import 'getVFCode_login.dart';

class PhoneLoginPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _PhoneLoginPageState();
  }
}

class _PhoneLoginPageState extends BaseWidgetState<PhoneLoginPage> {
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = true;
    backImgPath = "assets/images/login/icon_phoneLogin_back.png";
  }

  bool canGetCode = false;

  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 54.h, left: 25.w),
            child: Text(
              "请输入手机号",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 32.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30.w),
            child: Text(
              "以便获取验证码",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 22.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 32.h, left: 24.w, right: 24.w),
            height: 56.h,
            child: TextField(
                onChanged: (value) {
                  if (value.length >= 13) {
                    canGetCode = true;
                  } else {
                    canGetCode = false;
                  }
                  setState(() {});
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp("[0-9]"), allow: true),
                  InputFormat()
                ],
                style: TextStyle(
                    fontSize: 16.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.TextFildBlackColor), //输入文本的样式
                decoration: InputDecoration(
                    fillColor: ColorConstant.WhiteColor,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 13.w, right: 13.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.h),
                      borderSide: BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //未选中时候的颜色
                      borderRadius: BorderRadius.circular(28.h),
                      borderSide: BorderSide(
                        color: ColorConstant.WhiteColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //选中时外边框颜色
                      borderRadius: BorderRadius.circular(28.h),
                      borderSide: BorderSide(
                        color: ColorConstant.WhiteColor,
                      ),
                    ),
                    prefixIcon: Container(
                      padding: EdgeInsets.only(left: 13.w, right: 8.w),
                      child: Image(
                        image: AssetImage(
                            "assets/images/login/iocn_login_bluePhone.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      maxWidth: 51.w,
                      maxHeight: 51.w,
                    ))),
          ),
          Container(
              margin: EdgeInsets.only(top: 113.h, left: 24.w, right: 24.w),
              height: 55.h,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(canGetCode
                          ? ColorConstant.MainBlueColor
                          : ColorConstant.WhiteColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.h)))),
                  onPressed: () {
                    selectGetVFCodeLogin();
                  },
                  child: Container(
                    child: Center(
                      child: Container(
                        child: Text(
                          "获取验证码",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: canGetCode
                                ? ColorConstant.WhiteColor
                                : ColorConstant.Text_8E9AB,
                          ),
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  void selectGetVFCodeLogin() {
    if (!canGetCode) {
      return;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GetVFCodeLoginPage()));
  }
}
