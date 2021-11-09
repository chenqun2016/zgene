import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/screen_utils.dart';

typedef _CallBack = void Function();

class MyDialog extends Dialog {
  // final _CallBack callback;
  final String title;
  final String img;
  final String tureText;
  final String falseText;

  // 构造函数赋值
  MyDialog(
      {this.title = "",
      this.img = "",
      this.tureText = null,
      this.falseText = null});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Stack(children: [
          Center(
              child: Container(
                  decoration: new BoxDecoration(
                    color: ColorConstant.TextFildShadowE5Color,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    //设置四周边框
                    border: new Border.all(
                        width: 1, color: ColorConstant.WhiteColor),
                  ),
                  width: 344.w,
                  height: 256.h,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 90.h),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Text(
                                '${this.title}',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: ColorConstant.TextMainBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            btnView(context),
                          ],
                        ),
                      ),
                    ],
                  ))),
          Positioned(
            top: 214.h,
            left: (ScreenUtils.screenW(context) - 110.w) / 2,
            child: Image(
              image: AssetImage('${this.img}'),
              height: 110.w,
              width: 110.w,
            ),
          ),
        ]));
  }

  Widget btnView(BuildContext context) {
    if (this.falseText == null) {
      return Container(
        margin: EdgeInsets.only(top: 35.h),
        width: 144.w,
        height: 55.h,
        child: OutlinedButton(
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(width: 0, color: ColorConstant.MainBlueColor)),
                backgroundColor:
                    MaterialStateProperty.all(ColorConstant.MainBlueColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.h)))),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Container(
              child: Center(
                child: Container(
                  child: Text(
                    '${this.tureText}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.WhiteColor,
                    ),
                  ),
                ),
              ),
            )),
      );
    } else {
      return Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 35.h, left: 16.w),
            width: 144.w,
            height: 55.h,
            child: OutlinedButton(
                style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                        width: 1, color: ColorConstant.TextMainColor)),
                    backgroundColor:
                        MaterialStateProperty.all(ColorConstant.WhiteColor),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.h)))),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  child: Center(
                    child: Container(
                      child: Text(
                        '${this.falseText}',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.TextMainColor,
                        ),
                      ),
                    ),
                  ),
                )),
          ),
          Expanded(child: Container()),
          Container(
            margin: EdgeInsets.only(top: 35.h, right: 16.w),
            width: 144.w,
            height: 55.h,
            child: OutlinedButton(
                style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                        width: 0, color: ColorConstant.MainBlueColor)),
                    backgroundColor:
                        MaterialStateProperty.all(ColorConstant.MainBlueColor),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.h)))),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Container(
                  child: Center(
                    child: Container(
                      child: Text(
                        '${this.tureText}',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.WhiteColor,
                        ),
                      ),
                    ),
                  ),
                )),
          )
        ],
      );
    }
  }
}
