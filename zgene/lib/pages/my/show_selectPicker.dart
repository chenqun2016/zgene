import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/date_utils.dart';
import 'package:zgene/util/screen_utils.dart';

typedef _CallBack = void Function(String timeStr, String reportStr);
// ignore: unused_element
String _senderBackTime = "";
String _reporStrTime = "";

void showSelectPickerTool(BuildContext context, _CallBack callback) {
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 21.h, left: 16.w),
                  height: 25.h,
                  child: Text(
                    "预约上门时间",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.TextSecondColor,
                    ),
                  ),
                ),
                Container(child: selectTimePicker()),
              ],
            ),
            Positioned(
                top: 335.h,
                left: 0,
                child: Container(
                  width: ScreenUtils.screenW(context) / 3,
                  height: 50.h,
                  decoration: new BoxDecoration(
                    color: ColorConstant.TextFildBackColor,
                  ),
                )),
            Positioned(
                top: 335.h,
                left: 0,
                right: 0,
                child: Container(
                  height: 78.h,
                  decoration: new BoxDecoration(
                      color: ColorConstant.WhiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.h),
                          topRight: Radius.circular(20.h)),
                      boxShadow: [
                        BoxShadow(
                            color: ColorConstant.TextFildShadow0cColor,
                            offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                            blurRadius: 80.0, //阴影模糊程度
                            spreadRadius: 0 //阴影扩散程度
                            )
                      ]),
                  child: Container(
                      margin: EdgeInsets.only(
                        top: 16.h,
                        left: 96.w,
                        right: 96.w,
                        bottom: 24,
                      ),
                      // height: 44.h,
                      child: OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                width: 0, color: ColorConstant.WhiteColor)),
                            backgroundColor: MaterialStateProperty.all(
                                ColorConstant.MainBlueColor),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.h)),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            if (callback != null) {
                              callback(_senderBackTime, _reporStrTime);
                            }
                          },
                          child: Container(
                            child: Center(
                              child: Container(
                                child: Text(
                                  "确认",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.WhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ))),
                ))
          ],
        ),
      );
    },
  );
}

class selectTimePicker extends StatefulWidget {
  selectTimePicker({Key key}) : super(key: key);

  @override
  _selectTimePicker createState() => _selectTimePicker();
}

class _selectTimePicker extends State<selectTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: contextView(context),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screeningOverTime();
    callBackTime();
  }

  var dayData = ["今天", "明天", "后天"];
  int daySelectIndex = 0;
  int timeSelectIndex = 0;
  var todayTimeState = [];
  var todayTimeData = [
    "一小时内",
    "08:00-09:00",
    "09:00-10:00",
    "10:00-11:00",
    "11:00-12:00",
    "12:00-13:00",
    "13:00-14:00",
    "14:00-15:00",
    "15:00-16:00",
    "16:00-17:00",
    "17:00-18:00",
    "18:00-19:00",
    "19:00-20:00",
    "20:00-20:30"
  ];
  var otherTimeData = [
    "08:00-09:00",
    "09:00-10:00",
    "10:00-11:00",
    "11:00-12:00",
    "12:00-13:00",
    "13:00-14:00",
    "14:00-15:00",
    "15:00-16:00",
    "16:00-17:00",
    "17:00-18:00",
    "18:00-19:00",
    "19:00-20:00",
    "20:00-20:30"
  ];
  DateTime dayTime;

  Widget contextView(BuildContext context) {
    return Container(
      child: Row(
        children: [dayView(context), timeView(context)],
      ),
    );
  }

  Widget dayView(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          color: ColorConstant.TextFildBackColor,
        ),
        margin: EdgeInsets.only(top: 26.h),
        width: ScreenUtils.screenW(context) / 3,
        height: 263.h,
        child: Column(
          children: [
            Container(
              // height: 263.h,
              child: ListView.builder(
                itemCount: dayData.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      daySelectIndex = index;
                      timeSelectIndex = 0;
                      setState(() {});
                      callBackTime();
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                        color: index == daySelectIndex
                            ? ColorConstant.WhiteColor
                            : ColorConstant.TextFildBackColor,
                      ),
                      height: 48.h,
                      child: Center(
                        child: Text(
                          dayData[index],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: index == daySelectIndex
                                ? ColorConstant.TextMainColor
                                : ColorConstant.TextSecondColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
                height: 20,
                decoration: new BoxDecoration(
                  color: ColorConstant.TextFildBackColor,
                ))
          ],
        ));
  }

  Widget timeView(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          color: ColorConstant.WhiteColor,
        ),
        margin: EdgeInsets.only(top: 26.h),
        width: (ScreenUtils.screenW(context) / 3) * 2,
        height: 263.h,
        child: ListView.builder(
          itemCount:
              daySelectIndex == 0 ? todayTimeData.length : otherTimeData.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                if (!(daySelectIndex == 0 && todayTimeState[index])) {
                  timeSelectIndex = index;
                  setState(() {});
                  callBackTime();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 24.w),
                    decoration:
                        new BoxDecoration(color: ColorConstant.WhiteColor),
                    height: 48.h,
                    child: Center(
                      child: Text(
                        daySelectIndex == 0
                            ? todayTimeData[index]
                            : otherTimeData[index],
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: (daySelectIndex == 0 && todayTimeState[index])
                              ? ColorConstant.Text_8E9AB
                              : (index == timeSelectIndex
                                  ? ColorConstant.TextMainColor
                                  : ColorConstant.TextSecondColor),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                      decoration:
                          new BoxDecoration(color: ColorConstant.WhiteColor),
                      height: 48.h,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 21.w),
                              child: Text(
                                (daySelectIndex == 0 && todayTimeState[index])
                                    ? "已过期  "
                                    : "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.Text_8E9AB,
                                ),
                              ),
                            ),
                            Container(
                              width: 43.w,
                              child: Offstage(
                                offstage:
                                    index == timeSelectIndex ? false : true,
                                child: Container(
                                  margin: EdgeInsets.only(right: 23.w),
                                  child: Image(
                                      width: 20.w,
                                      height: 20.w,
                                      image: AssetImage(
                                          "assets/images/mine/icon_sendBack_select.png")),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
        ));
  }

  var week = [];

  void screeningOverTime() {
    DateTime dateTime = DateTime.now();

    for (var time in todayTimeData) {
      if (time == "一小时内") {
        todayTimeState += [false];
      } else {
        String endTime = time.substring(time.length - 5);
        DateTime currentTime = new DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day + daySelectIndex,
            int.parse(endTime.substring(0, 2)),
            int.parse(endTime.substring(endTime.length - 2)));
        dayTime = currentTime;

        if (currentTime.millisecondsSinceEpoch <
            dateTime.millisecondsSinceEpoch) {
          todayTimeState += [true];
        } else {
          todayTimeState += [false];
        }
      }
    }

    for (var i = 0; i < dayData.length; i++) {
      // CusDateUtils.getWeek(dayTime)
      var dayCount = DateTime(dateTime.year, dateTime.month + 1, 0).day;
      if (dateTime.day < dayCount) {
        DateTime currentTime = new DateTime(dateTime.year, dateTime.month,
            dateTime.day + i, dateTime.hour, dateTime.minute);
        week += [CusDateUtils.getWeek(currentTime)];
      } else {
        DateTime currentTime = new DateTime(dateTime.year, dateTime.month + i,
            1, dateTime.hour, dateTime.minute);
        week += [CusDateUtils.getWeek(currentTime)];
      }
    }
  }

  void callBackTime() {
    _senderBackTime = dayData[daySelectIndex] +
        '  (' +
        week[daySelectIndex] +
        ')  ' +
        (daySelectIndex == 0
            ? todayTimeData[timeSelectIndex]
            : otherTimeData[timeSelectIndex]);

    DateTime dateTime = DateTime.now();
    var dayCount = DateTime(dateTime.year, dateTime.month + 1, 0).day;

    if (daySelectIndex == 0) {
      if (timeSelectIndex == 0) {
        _reporStrTime = dateTime.toString();
        _reporStrTime = dateTime.year.toString() +
            "-" +
            dateTime.month.toString() +
            "-" +
            dateTime.day.toString() +
            " " +
            dateTime.hour.toString() +
            ":" +
            dateTime.minute.toString();
      } else {
        if (dateTime.day < dayCount) {
          _reporStrTime = dateTime.year.toString() +
              "-" +
              dateTime.month.toString() +
              "-" +
              (dateTime.day + daySelectIndex).toString() +
              " " +
              todayTimeData[timeSelectIndex].substring(0, 5);
        } else {
          _reporStrTime = dateTime.year.toString() +
              "-" +
              (dateTime.month + daySelectIndex).toString() +
              "-" +
              "1 " +
              todayTimeData[timeSelectIndex].substring(0, 5);
        }
      }
    } else {
      if (dateTime.day < dayCount) {
        _reporStrTime = dateTime.year.toString() +
            "-" +
            dateTime.month.toString() +
            "-" +
            (dateTime.day + daySelectIndex).toString() +
            " " +
            otherTimeData[timeSelectIndex].substring(0, 5);
      } else {
        _reporStrTime = _reporStrTime = dateTime.year.toString() +
            "-" +
            (dateTime.month + daySelectIndex).toString() +
            "-" +
            "1 " +
            otherTimeData[timeSelectIndex].substring(0, 5);
      }
    }
  }
}
