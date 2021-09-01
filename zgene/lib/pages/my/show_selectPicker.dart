import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';

void showSelectPickerTool(BuildContext context) {
  showModalBottomSheet(
    barrierColor: ColorConstant.AppleBlack99Color,
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.h), topRight: Radius.circular(20.h))),
    builder: (ctx) {
      return Container(
        height: 419.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorConstant.WhiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.h),
                topRight: Radius.circular(20.h))),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 21.h, left: 16.w),
              height: 22.h,
              width: 80.w,
              child: Text(
                "付费方式：",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.TextSecondColor,
                ),
              ),
            ),
            Container(child: selectTimePicker())
          ],
        ),
      );
    },
  );
}

class selectTimePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: contextView(context),
    );
  }

  Widget contextView(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Pickers.showDatePicker(
            context,
            onConfirm: (p) {
              print('longer >>> 返回数据：$p');
            },
            // onChanged: (p) => print(p),
          );
        },
        child: Text('Demo'));
  }
}
