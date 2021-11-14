import 'dart:async';
import 'dart:collection';

import 'package:base/event/event_bus.dart';
import 'package:base/http/http_utils.dart';
import 'package:base/util/sp_utils.dart';
import 'package:base/widget/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/util/isChina_phone.dart';
import 'package:zgene/util/phonetextFild_input.dart';

class MyNewPhonePage extends StatefulWidget {
  @override
  BaseWidgetState createState() {
    return _MyNewPhonePageState();
  }
}

class _MyNewPhonePageState extends BaseWidgetState<MyNewPhonePage> {
  @override
  void customInitState() {
    super.customInitState();
    showHead = true;
    backImgPath = "assets/images/login/icon_bindingPhone_back.png";
  }

  bool isPhoneSuccess = false;
  bool isVFCodeSuccess = false;

  String _verifyStr = ' 获取验证码 ';
  bool _isAvailableGetVCode = true; //是否可以获取验证码，默认为`false`
  String _phoneErrorText = null;
  String _phoneText = "";
  String _verifyText = "";

  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  /// 倒计时的秒数，默认60秒。
  final int countdown = 60;

  bool isPhoneSelect = false;
  bool isCodeSelect = false;

  FocusNode _phonefocusNode = FocusNode();
  FocusNode _codefocusNode = FocusNode();

  void initState() {
    super.initState();
    _seconds = countdown;
    // _startTimer();
    _phonefocusNode.addListener(() {
      if (!_phonefocusNode.hasFocus) {
        isPhoneSelect = false;
      } else {
        isPhoneSelect = true;
      }
      setState(() {});
    });
    _codefocusNode.addListener(() {
      if (!_codefocusNode.hasFocus) {
        isCodeSelect = false;
      } else {
        isCodeSelect = true;
      }
      setState(() {});
    });
  }

  @override
  Widget customBuildBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 54.h, left: 25.w),
            child: Text(
              "输入新手机号",
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
            margin: EdgeInsets.only(left: 30.w, top: 10.h),
            child: Text(
              "您当前的手机号是 " +
                  SpUtils()
                      .getStorageDefault(SpConstant.UserMobile, "")
                      .toString() +
                  ",\n更换后新手机号将作为新的登录账号。",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: ColorConstant.TextMainBlack,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(28.h),
                boxShadow: [
                  BoxShadow(
                      color: isPhoneSelect
                          ? ColorConstant.TextFildShadowColor
                          : ColorConstant.TextFildShadow00Color,
                      offset: Offset(0.0, 20.0), //阴影xy轴偏移量
                      blurRadius: 40.0, //阴影模糊程度
                      spreadRadius: 0 //阴影扩散程度
                      )
                ]),
            margin: EdgeInsets.only(top: 32.h, left: 24.w, right: 24.w),
            height: 56.h,
            child: TextField(
                focusNode: _phonefocusNode,
                onChanged: (value) {
                  if (value.length >= 13) {
                    isPhoneSuccess = true;
                  } else {
                    isPhoneSuccess = false;
                    _phoneErrorText = null;
                  }
                  _phoneText = value;
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
                    errorText: _phoneErrorText,
                    hintText: "请输入新的手机号",
                    //设置输入文本框的提示文字的样式
                    hintStyle: TextStyle(
                      color: ColorConstant.TextFildBlackColor,
                      fontSize: 16.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      // textBaseline: TextBaseline.ideographic,
                    ),
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
                            "assets/images/login/icon_bindingPhone_phone.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      maxWidth: 51.w,
                      maxHeight: 51.w,
                    ))),
          ),
          Stack(children: [
            Container(
              decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(28.h),
                  boxShadow: [
                    BoxShadow(
                        color: isCodeSelect
                            ? ColorConstant.TextFildShadowColor
                            : ColorConstant.TextFildShadow00Color,
                        offset: Offset(0.0, 20.0), //阴影xy轴偏移量
                        blurRadius: 40.0, //阴影模糊程度
                        spreadRadius: 0 //阴影扩散程度
                        )
                  ]),
              margin: EdgeInsets.only(top: 17.h, left: 24.w, right: 24.w),
              height: 56.h,
              child: TextField(
                  focusNode: _codefocusNode,
                  onChanged: (value) {
                    if (value.length >= 6) {
                      isVFCodeSuccess = true;
                    } else {
                      isVFCodeSuccess = false;
                    }
                    _verifyText = value;

                    setState(() {});
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp("[0-9]"), allow: true),
                    LengthLimitingTextInputFormatter(6)
                  ],
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.TextFildBlackColor), //输入文本的样式
                  decoration: InputDecoration(
                      hintText: "请输入验证码",
                      //设置输入文本框的提示文字的样式
                      hintStyle: TextStyle(
                        color: ColorConstant.TextFildBlackColor,
                        fontSize: 16.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        // textBaseline: TextBaseline.ideographic,
                      ),
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
                              "assets/images/login/icon_bindingPhone_security.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        maxWidth: 51.w,
                        maxHeight: 51.w,
                      ))),
            ),
            Positioned(
                top: 17.h,
                right: 34.w,
                child: Container(
                  child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.h))),
                        side: MaterialStateProperty.all(
                          BorderSide(
                              color: ColorConstant.MainBlueColor, width: 1),
                        ),
                      ),
                      onPressed: _seconds == countdown
                          ? () {
                              getVerifyCode();
                              //获取验证码
                            }
                          : null,
                      child: Center(
                        child: Text(
                          _verifyStr,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.MainBlueColor,
                          ),
                        ),
                      )),
                ))
          ]),
          Container(
              margin: EdgeInsets.only(top: 154.h, left: 24.w, right: 24.w),
              height: 55.h,
              child: OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                          width: 0, color: ColorConstant.WhiteColor)),
                      backgroundColor: MaterialStateProperty.all(
                          (isPhoneSuccess && isVFCodeSuccess)
                              ? ColorConstant.MainBlueColor
                              : ColorConstant.WhiteColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.h)))),
                  onPressed: () {
                    selectNext();
                  },
                  child: Container(
                    child: Center(
                      child: Container(
                        child: Text(
                          "完成",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: (isPhoneSuccess && isVFCodeSuccess)
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

  //获取验证码
  void getVerifyCode() {
    var number = _phoneText.replaceAll(new RegExp(r"\s+\b|\b\s"), "");

    if (!isPhoneUtils.isChinaPhoneLegal(number)) {
      _phoneErrorText = "请填写正确格式的手机号！";
      setState(() {});
      return;
    } else {
      _phoneErrorText = null;
      setState(() {});
    }

    setState(() {});

    Map<String, dynamic> map = new HashMap();
    map["mobile"] = number;

    HttpUtils.requestHttp(
      ApiConstant.loginSms,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) {
        EasyLoading.dismiss();
        _startTimer();
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
      },
    );
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      _isAvailableGetVCode = false;
      _verifyStr = '${_seconds}s';
      if (_seconds == 0) {
        _verifyStr = ' 重新获取 ';
        _isAvailableGetVCode = true;
        _seconds = countdown;
        _cancelTimer();
      }
      setState(() {});
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cancelTimer();
    _timer = null;
    super.dispose();
  }

  void selectNext() {
    var number = _phoneText.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    if (!isPhoneUtils.isChinaPhoneLegal(number)) {
      _phoneErrorText = "请填写正确格式的手机号！";
      setState(() {});
      return;
    } else {
      _phoneErrorText = null;
      setState(() {});
    }
    Map<String, dynamic> map = new HashMap();
    map["mobile"] = number;
    map["code"] = _verifyText;
    ;

    HttpUtils.requestHttp(
      ApiConstant.bindAppPhone,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) async {
        EasyLoading.showSuccess('修改成功');
        var spUtils = SpUtils();
        spUtils.setStorage(SpConstant.Token, data["token"]);
        spUtils.setStorage(SpConstant.IsLogin, true);
        spUtils.setStorage(SpConstant.Uid, data["uid"]);
        spUtils.setStorage(SpConstant.UserMobile, number);
        HttpUtils.clear();

        // NotificationCenter.instance
        //     .postNotification(NotificationName.GetUserInfo, null);
        bus.emit(CommonConstant.refreshMine);
        Navigator.of(context)
          ..pop()
          ..pop();
      },
      onError: (code, error) {
        EasyLoading.showError(error ?? "");
      },
    );
  }
}
