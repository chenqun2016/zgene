import 'package:base/navigator/navigator_util.dart';
import 'package:base/widget/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/pages/login/change_Password.dart';
import 'package:zgene/pages/my/cancellation_account.dart';

class accountSecurityPage extends StatefulWidget {
  @override
  BaseWidgetState createState() {
    return _accountSecurityPageState();
  }
}

class _accountSecurityPageState extends BaseWidgetState<accountSecurityPage> {
  @override
  void customInitState() {
    super.customInitState();
    showHead = true;
    backImgPath = "assets/images/mine/icon_account_Secutity_back.png";
    pageWidgetTitle = "账号安全";
    textStyle = TextStyle(
      fontSize: 16.sp,
      color: Color(0xFF112950),
      fontWeight: FontWeight.w500,
    );
  }

  var textStyle;

  @override
  Widget customBuildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 20.h, 16, 20.h),
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
          // GestureDetector(
          //   onTap: () {
          //     _onTapEvent(0);
          //   },
          //   behavior: HitTestBehavior.opaque,
          //   child: Stack(
          //     children: [
          //       Container(
          //           width: double.infinity,
          //           height: 45,
          //           alignment: Alignment.centerLeft,
          //           child: Text(
          //             "修改密码",
          //             style: textStyle,
          //           )),
          //       Positioned(
          //         right: 0,
          //         top: 15,
          //         child: Image(
          //           image: AssetImage("assets/images/mine/icon_my_right.png"),
          //           height: 16,
          //           width: 16,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
                      "注销账号",
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
        ],
      ),
    );
  }

  _onTapEvent(index) {
    switch (index) {
      case 0:
        NavigatorUtil.push(context, ChangePasswordPage());
        break;
      case 1:
        NavigatorUtil.push(context, cancellationAccountPage());
        break;
    }
  }
}
