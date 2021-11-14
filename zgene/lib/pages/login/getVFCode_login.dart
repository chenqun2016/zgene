import 'dart:async';
import 'dart:collection';

import 'package:base/constant/color_constant.dart';
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
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/constant/sp_constant.dart';
import 'package:zgene/constant/statistics_constant.dart';
import 'package:zgene/util/umeng_utils.dart';

class GetVFCodeLoginPage extends StatefulWidget {
  String phoneText;
  GetVFCodeLoginPage({Key key, this.phoneText}) : super(key: key);

  @override
  BaseWidgetState createState() {
    return _GetVFCodeLoginPageState();
  }
}

class _GetVFCodeLoginPageState extends BaseWidgetState<GetVFCodeLoginPage> {
  @override
  void customInitState() {
    super.customInitState();
    showHead = true;
    backImgPath = "assets/images/login/icon_login_getVFCode_back.png";
  }

  bool canLogin = false;
  String _verifyStr = ' 60s ';
  bool _isAvailableGetVCode = true; //是否可以获取验证码，默认为`false`
  bool isTextFildSelect = false;
  String _verifyText = "";
  FocusNode _focusNode = FocusNode();

  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  /// 倒计时的秒数，默认60秒。
  final int countdown = 60;

  void initState() {
    super.initState();
    print(99999999999);
    print(widget.phoneText);
    _seconds = countdown;
    _startTimer();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        isTextFildSelect = false;
      } else {
        isTextFildSelect = true;
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
              "请输入验证码",
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
              "未注册的手机号验证后自动创建Z基因账户",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorConstant.Text_9395A4Gray,
              ),
            ),
          ),
          Stack(children: [
            Container(
              decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(28.h),
                  boxShadow: [
                    BoxShadow(
                        color: isTextFildSelect
                            ? ColorConstant.TextFildShadowColor
                            : ColorConstant.TextFildShadow00Color,
                        offset: Offset(0.0, 20.0), //阴影xy轴偏移量
                        blurRadius: 40.0, //阴影模糊程度
                        spreadRadius: 0 //阴影扩散程度
                        )
                  ]),
              margin: EdgeInsets.only(top: 50.h, left: 24.w, right: 24.w),
              height: 56.h,
              child: TextField(
                  focusNode: _focusNode,
                  onChanged: (value) {
                    if (value.length >= 6) {
                      canLogin = true;
                    } else {
                      canLogin = false;
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
                              "assets/images/login/iocn_login_security.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        maxWidth: 51.w,
                        maxHeight: 51.w,
                      ))),
            ),
            Positioned(
                top: 50.h,
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
              margin: EdgeInsets.only(top: 113.h, left: 24.w, right: 24.w),
              height: 55.h,
              child: OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                          width: 0, color: ColorConstant.WhiteColor)),
                      backgroundColor: MaterialStateProperty.all(canLogin
                          ? ColorConstant.MainBlueColor
                          : ColorConstant.WhiteColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.h)))),
                  onPressed: () {
                    loginIn();
                  },
                  child: Container(
                    child: Center(
                      child: Container(
                        child: Text(
                          "进入Z基因研究所",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: canLogin
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
    setState(() {});

    Map<String, dynamic> map = new HashMap();
    map["mobile"] = widget.phoneText;

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

  void loginIn() {
    if (_verifyText.length < 6) {
      setState(() {});
      return;
    }
    Map<String, dynamic> map = new HashMap();
    map["mobile"] = widget.phoneText;
    map["code"] = _verifyText;

    HttpUtils.requestHttp(
      ApiConstant.loginApp_phone,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (data) async {
        EasyLoading.showSuccess('登录成功');
        UmengUtils.onEvent(StatisticsConstant.MY_PAGE, {
          StatisticsConstant.KEY_UMENG_L2: StatisticsConstant.MY_PAGE_LOGIN_OK
        });
        var spUtils = SpUtils();
        spUtils.setStorage(SpConstant.Token, data["token"]);
        spUtils.setStorage(SpConstant.IsLogin, true);
        spUtils.setStorage(SpConstant.Uid, data["uid"]);
        HttpUtils.clear();
        print("登录成功");
        print(spUtils.getStorageDefault(SpConstant.Token, ""));
        // NotificationCenter.instance
        //     .postNotification(NotificationName.GetUserInfo, null);
        Navigator.of(context).popUntil((route) => route.isFirst);
        bus.emit(CommonConstant.refreshMine);
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
      _verifyStr = ' ${_seconds}s ';
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
}
