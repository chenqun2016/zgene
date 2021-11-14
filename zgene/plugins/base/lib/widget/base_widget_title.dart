import 'package:base/constant/color_constant.dart';
import 'package:base/widget/base_widget.dart';
import 'package:base/widget/my_inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///页面基类title
class BaseWidgetTitle extends StatefulWidget {
  bool isShowBack;
  Widget? customHeaderBack;
  String pageWidgetTitle;
  Widget? headerRightBtn;

  BaseWidgetTitle(
      {Key? key,
      required this.isShowBack,
      this.customHeaderBack,
      required this.pageWidgetTitle,
      this.headerRightBtn})
      : super(key: key);

  @override
  _BaseWidgetTitleState createState() => _BaseWidgetTitleState();
}

class _BaseWidgetTitleState extends State<BaseWidgetTitle> {
  @override
  Widget build(BuildContext context) {
    var alpha = 255 * (MyInheritedWidget.of(context) / APPBAR_SCORLL_OFFSET);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(alpha.toInt(), 255, 255, 255),
      ),
      height: 55.h + MediaQuery.of(context).padding.top,
      child: Stack(
        children: [
          Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 16.w,
              child: Container(
                  height: 55.h,
                  child: widget.isShowBack ? widget.customHeaderBack : null)),
          Positioned(
            left: 80.w,
            right: 80.w,
            top: MediaQuery.of(context).padding.top,
            child: Container(
              height: 55.h,
              child: Center(
                child: Text(
                  widget.pageWidgetTitle,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.TextMainBlack,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).padding.top,
              right: 16.w,
              child: Container(height: 55.h, child: widget.headerRightBtn))
        ],
      ),
    );
  }
}
