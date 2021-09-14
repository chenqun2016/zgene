import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/login/change_Password.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/ui_uitls.dart';

import 'my_address_list.dart';

class cancellationAccountPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _cancellationAccountPageState();
  }
}

class _cancellationAccountPageState
    extends BaseWidgetState<cancellationAccountPage> {
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = true;
    backImgPath = "assets/images/login/icon_cancel_account_back.png";
    pageWidgetTitle = "注销账号";
    textStyle = TextStyle(
      fontSize: 16.sp,
      color: Color(0xFF112950),
      fontWeight: FontWeight.w500,
    );
  }

  var textStyle;

  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height - 100,
      child: Stack(
        children: [
          Column(
            children: [
              contentView(),
              operationView(),
            ],
          ),
          Positioned(
            bottom: 40.h,
            left: 16.w,
            right: 16.w,
            // height: 55,
            child: Text(
              "Z基因，您的健康管家",
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

  Widget contentView() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "感谢您对Z基因的信任!",
            textAlign: TextAlign.left,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 18.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: ColorConstant.TextMainBlack,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 13.h),
            child: Text(
              "如果处于某些原因您要注销自己的账户，可以直接联系Z基因客服QQ。在您确认注销之前请务必充分考虑，注销操作一旦完成，Z基因将无法再次为您提供您的数据和信息。",
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 16.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                color: ColorConstant.TextMainBlack,
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
          GestureDetector(
            onTap: () {
              _onTapEvent(0);
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                    height: 45,
                    alignment: Alignment.centerRight,
                    child: Text(
                      "客服（QQ）",
                      style: textStyle,
                    )),
                Expanded(child: Container()),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "1256019395",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorConstant.MainBlueColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _onTapEvent(1);
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                    height: 45,
                    alignment: Alignment.centerRight,
                    child: Text(
                      "服务时间",
                      style: textStyle,
                    )),
                Expanded(child: Container()),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "周一至周五10:00~18:00",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorConstant.Text_5E6F88,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
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
        Clipboard.setData(
            ClipboardData(text: CommonConstant.App_Contact_Wx_Code));
        EasyLoading.showSuccess('客服（QQ）复制成功');
        break;
      case 1:
        break;
    }
  }
}
