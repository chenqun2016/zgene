import 'package:base/constant/color_constant.dart';
import 'package:base/util/sp_utils.dart';
import 'package:base/widget/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/sp_constant.dart';

class contantUsPage extends StatefulWidget {
  @override
  BaseWidgetState createState() {
    return _contantUsPageState();
  }
}

class _contantUsPageState extends BaseWidgetState<contantUsPage> {
  @override
  void customInitState() {
    super.customInitState();
    showHead = true;
    backImgPath = "assets/images/mine/icon_contant_us_back.png";
    pageWidgetTitle = "联系客服";
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
      margin: EdgeInsets.only(top: 18.h),
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
          Container(
            margin: EdgeInsets.only(top: 14.h, left: 119.w, right: 119.w),
            child: Image(
              image: AssetImage("assets/images/mine/icon_contant_us_top.png"),
              height: 108.h,
              // width: 97.w,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 46.h),
            child: GestureDetector(
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
                        SpUtils()
                            .getStorageDefault(SpConstant.appKefuQq, "")
                            .toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorConstant.MainBlueColor,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                ],
              ),
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
                      SpUtils()
                          .getStorageDefault(SpConstant.appServiceTime, "")
                          .toString(),
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
        Clipboard.setData(ClipboardData(
            text: SpUtils()
                .getStorageDefault(SpConstant.appKefuQq, "")
                .toString()));
        EasyLoading.showSuccess('客服（QQ）复制成功');
        break;
      case 1:
        break;
    }
  }
}
