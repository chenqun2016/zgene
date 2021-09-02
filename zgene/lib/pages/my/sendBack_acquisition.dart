import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/pages/my/show_selectPicker.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/screen_utils.dart';
import 'package:flutter_pickers/pickers.dart';

class SendBackAcquisitionPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _SendBackAcquisitionPageState();
  }
}

class _SendBackAcquisitionPageState
    extends BaseWidgetState<SendBackAcquisitionPage> {
  @override
  void pageWidgetInitState() {
    super.pageWidgetInitState();
    showHead = true;
    backImgPath = "assets/images/mine/icon_sendBack_acquisitionBack.png";
    pageWidgetTitle = "回寄采集器";
    customRightBtnText = "采集引导";
  }

  String sendBackText = "江西省南昌市高新区南昌国家医药国际创新园联合研究院14号楼";
  bool isCanOrder = false;
  @override
  Widget viewPageBody(BuildContext context) {
    return Container(
      child: Column(
        children: [
          sendBackTopView(context),
          needSendInfoView(context),
          sendPeopleView(context),
          sendBackTimeView(context),
          deliverTheGoodsView(context),
          atOnceOrder(context)
        ],
      ),
    );
  }

  ///顶部视图View
  Widget sendBackTopView(BuildContext context) {
    return Container(
      height: 202.h,
      child: Stack(
        children: [
          Positioned(
              top: 35.h,
              left: 16.w,
              right: 16.w,
              child: Container(
                decoration: new BoxDecoration(
                  color: ColorConstant.WhiteColorB2,
                  borderRadius: BorderRadius.all(Radius.circular(20.h)),
                  //设置四周边框
                  border:
                      new Border.all(width: 1, color: ColorConstant.WhiteColor),
                ),
                height: 167.h,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 87.h),
                      child: Text(
                        "预约顺丰快递上门取件",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.TextMainBlack,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      child: Text(
                        "您也可以自己回寄，选择到付即可。",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.Text_5E6F88,
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
              top: -7.h,
              left: 0,
              right: 0,
              child: Container(
                  child: Center(
                      child: Image(
                          width: 126.w,
                          height: 126.w,
                          image: AssetImage(
                              "assets/images/mine/icon_sendBack_top.png")))))
        ],
      ),
    );
  }

  ///当前需要回寄的样本View
  Widget needSendInfoView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
      height: 144.h,
      width: ScreenUtils.screenW(context) - 32.w,
      decoration: new BoxDecoration(
        color: ColorConstant.WhiteColorB2,
        borderRadius: BorderRadius.all(Radius.circular(20.h)),
        //设置四周边框
        border: new Border.all(width: 1, color: ColorConstant.WhiteColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 19.h, left: 16.w),
            child: Text(
              "当前需要回寄的样本",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorConstant.TextSecondColor,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.h, left: 16.w),
                child: Image(
                    width: 20.h,
                    height: 20.h,
                    image: AssetImage(
                        "assets/images/mine/icon_sendBack_people.png")),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.h, left: 12.w),
                child: Text(
                  "姓名：张三",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextSecondColor,
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15.h, left: 16.w),
                child: Image(
                    width: 20.h,
                    height: 20.h,
                    image: AssetImage(
                        "assets/images/mine/icon_sendBack_pill.png")),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.h, left: 12.w),
                child: Text(
                  "采集样本编号：58554585",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextSecondColor,
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(top: 15.h, right: 16.w),
                child: Image(
                    width: 20.h,
                    height: 20.h,
                    image: AssetImage(
                        "assets/images/mine/icon_sendBack_select.png")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///寄件人信息View
  Widget sendPeopleView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
      height: 272.h,
      width: ScreenUtils.screenW(context) - 32.w,
      decoration: new BoxDecoration(
        color: ColorConstant.WhiteColorB2,
        borderRadius: BorderRadius.all(Radius.circular(20.h)),
        //设置四周边框
        border: new Border.all(width: 1, color: ColorConstant.WhiteColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.h, left: 16.w),
                // height: 25.h,
                child: Text(
                  "寄件人信息",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextSecondColor,
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(top: 20.h, right: 16.w),
                child: InkWell(
                  onTap: () {
                    print(123);
                  },
                  child: Image(
                      width: 25.h,
                      height: 25.h,
                      image: AssetImage(
                          "assets/images/mine/icon_sendBack_add.png")),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h, left: 16.w),
                height: 40.h,
                child: Image(
                    width: 20.w,
                    height: 20.w,
                    image: AssetImage(
                        "assets/images/mine/icon_sendBack_people.png")),
              ),
              Container(
                margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 16.w),
                height: 40.h,
                width: ScreenUtils.screenW(context) - 98.w,
                child: TextField(
                    // keyboardType:
                    //     TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.TextSecondColor),
                    //输入文本的样式
                    decoration: InputDecoration(
                      hintText: "请填写寄件人姓名",
                      //设置输入文本框的提示文字的样式
                      hintStyle: TextStyle(
                        color: ColorConstant.Text_5E6F88,
                        fontSize: 15.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        // textBaseline: TextBaseline.ideographic,
                      ),
                      fillColor: ColorConstant.TextFildBackColor,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 13.w, right: 13.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.h),
                        borderSide: BorderSide(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        //未选中时候的颜色
                        borderRadius: BorderRadius.circular(8.h),
                        borderSide: BorderSide(
                          color: ColorConstant.TextFildBackColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        //选中时外边框颜色
                        borderRadius: BorderRadius.circular(8.h),
                        borderSide: BorderSide(
                          color: ColorConstant.TextFildBackColor,
                        ),
                      ),
                    )),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h, left: 16.w),
                height: 40.h,
                child: Image(
                    width: 20.w,
                    height: 20.w,
                    image: AssetImage(
                        "assets/images/mine/icon_sendBack_phone.png")),
              ),
              Container(
                margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 16.w),
                height: 40.h,
                width: ScreenUtils.screenW(context) - 98.w,
                child: TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.TextSecondColor),
                    //输入文本的样式
                    decoration: InputDecoration(
                      hintText: "请填写手机号码",
                      //设置输入文本框的提示文字的样式
                      hintStyle: TextStyle(
                        color: ColorConstant.Text_5E6F88,
                        fontSize: 15.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        // textBaseline: TextBaseline.ideographic,
                      ),
                      fillColor: ColorConstant.TextFildBackColor,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 13.w, right: 13.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.h),
                        borderSide: BorderSide(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        //未选中时候的颜色
                        borderRadius: BorderRadius.circular(8.h),
                        borderSide: BorderSide(
                          color: ColorConstant.TextFildBackColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        //选中时外边框颜色
                        borderRadius: BorderRadius.circular(8.h),
                        borderSide: BorderSide(
                          color: ColorConstant.TextFildBackColor,
                        ),
                      ),
                    )),
              )
            ],
          ),
          Stack(children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12.h, left: 16.w),
                  height: 40.h,
                  child: Image(
                      width: 20.w,
                      height: 20.w,
                      image: AssetImage(
                          "assets/images/mine/icon_sendBack_address.png")),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 16.w),
                  height: 40.h,
                  width: ScreenUtils.screenW(context) - 98.w,
                  child: TextField(
                      enableInteractiveSelection: false,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.TextSecondColor),
                      //输入文本的样式
                      decoration: InputDecoration(
                        hintText:
                            sendBackAddress == "" ? "请选择所在地区" : sendBackAddress,
                        //设置输入文本框的提示文字的样式
                        hintStyle: sendBackAddress == ""
                            ? TextStyle(
                                color: ColorConstant.Text_5E6F88,
                                fontSize: 15.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                // textBaseline: TextBaseline.ideographic,
                              )
                            : TextStyle(
                                color: ColorConstant.TextSecondColor,
                                fontSize: 15.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                // textBaseline: TextBaseline.ideographic,
                              ),
                        fillColor: ColorConstant.TextFildBackColor,
                        filled: true,
                        contentPadding:
                            EdgeInsets.only(left: 13.w, right: 13.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.h),
                          borderSide: BorderSide(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          //未选中时候的颜色
                          borderRadius: BorderRadius.circular(8.h),
                          borderSide: BorderSide(
                            color: ColorConstant.TextFildBackColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          //选中时外边框颜色
                          borderRadius: BorderRadius.circular(8.h),
                          borderSide: BorderSide(
                            color: ColorConstant.TextFildBackColor,
                          ),
                        ),
                      )),
                )
              ],
            ),
            Positioned(
              top: 21.h,
              right: 30.w,
              child: InkWell(
                onTap: () {
                  selectAddress();
                },
                child: Image(
                    width: 22.h,
                    height: 22.h,
                    image: AssetImage(
                        "assets/images/mine/icon_sendBack_down.png")),
              ),
            )
          ]),
          Container(
            margin: EdgeInsets.only(top: 12.h, left: 48.w, right: 16.w),
            height: 40.h,
            width: ScreenUtils.screenW(context) - 96.w,
            child: TextField(

                // keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                    fontSize: 18.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.TextSecondColor),
                //输入文本的样式
                decoration: InputDecoration(
                  hintText: "请填写详细地址",
                  //设置输入文本框的提示文字的样式
                  hintStyle: TextStyle(
                    color: ColorConstant.Text_5E6F88,
                    fontSize: 15.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    // textBaseline: TextBaseline.ideographic,
                  ),
                  fillColor: ColorConstant.TextFildBackColor,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 13.w, right: 13.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.h),
                    borderSide: BorderSide(),
                  ),
                  enabledBorder: OutlineInputBorder(
                    //未选中时候的颜色
                    borderRadius: BorderRadius.circular(8.h),
                    borderSide: BorderSide(
                      color: ColorConstant.TextFildBackColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //选中时外边框颜色
                    borderRadius: BorderRadius.circular(8.h),
                    borderSide: BorderSide(
                      color: ColorConstant.TextFildBackColor,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  /// 预约取件时间View
  Widget sendBackTimeView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
      height: 120.h,
      width: ScreenUtils.screenW(context) - 32.w,
      decoration: new BoxDecoration(
        color: ColorConstant.WhiteColorB2,
        borderRadius: BorderRadius.all(Radius.circular(20.h)),
        //设置四周边框
        border: new Border.all(width: 1, color: ColorConstant.WhiteColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 19.h, left: 16.w),
            child: Text(
              "预约取件时间",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorConstant.TextSecondColor,
              ),
            ),
          ),
          Stack(children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12.h, left: 16.w),
                  height: 40.h,
                  child: Image(
                      width: 20.w,
                      height: 20.w,
                      image: AssetImage(
                          "assets/images/mine/icon_sendBack_time.png")),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 16.w),
                  height: 40.h,
                  width: ScreenUtils.screenW(context) - 98.w,
                  child: TextField(
                      enableInteractiveSelection: false,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.TextSecondColor),
                      //输入文本的样式
                      decoration: InputDecoration(
                        hintText: sendBackTime == "" ? "请选择上门时间" : sendBackTime,
                        //设置输入文本框的提示文字的样式
                        hintStyle: sendBackTime == ""
                            ? TextStyle(
                                color: ColorConstant.Text_5E6F88,
                                fontSize: 15.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                // textBaseline: TextBaseline.ideographic,
                              )
                            : TextStyle(
                                color: ColorConstant.TextSecondColor,
                                fontSize: 15.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                // textBaseline: TextBaseline.ideographic,
                              ),
                        fillColor: ColorConstant.TextFildBackColor,
                        filled: true,
                        contentPadding:
                            EdgeInsets.only(left: 13.w, right: 13.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.h),
                          borderSide: BorderSide(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          //未选中时候的颜色
                          borderRadius: BorderRadius.circular(8.h),
                          borderSide: BorderSide(
                            color: ColorConstant.TextFildBackColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          //选中时外边框颜色
                          borderRadius: BorderRadius.circular(8.h),
                          borderSide: BorderSide(
                            color: ColorConstant.TextFildBackColor,
                          ),
                        ),
                      )),
                )
              ],
            ),
            Positioned(
              top: 21.h,
              right: 30.w,
              child: InkWell(
                onTap: () {
                  selectTime();
                },
                child: Image(
                    width: 22.h,
                    height: 22.h,
                    image: AssetImage(
                        "assets/images/mine/icon_sendBack_down.png")),
              ),
            )
          ]),
        ],
      ),
    );
  }

  ///收货信息View
  Widget deliverTheGoodsView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
      // height: 180.h +
      //     boundingTextSize(
      //             sendBackText,
      //             TextStyle(
      //               fontSize: 14.sp,
      //               fontStyle: FontStyle.normal,
      //               fontWeight: FontWeight.w400,
      //               color: ColorConstant.TextThreeColor,
      //             ),
      //             maxWidth: ScreenUtils.screenW(context) - 178.w)
      //         .height
      //         .h,
      width: ScreenUtils.screenW(context) - 32.w,
      decoration: new BoxDecoration(
        color: ColorConstant.WhiteColorB2,
        borderRadius: BorderRadius.all(Radius.circular(20.h)),
        //设置四周边框
        border: new Border.all(width: 1, color: ColorConstant.WhiteColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 19.h, left: 16.w),
            child: Text(
              "收货信息",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorConstant.TextSecondColor,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 12.h, left: 16.w, right: 16.w, bottom: 24.h),
            // height: 100.h +
            //     boundingTextSize(
            //             sendBackText,
            //             TextStyle(
            //               fontSize: 14.sp,
            //               fontStyle: FontStyle.normal,
            //               fontWeight: FontWeight.w400,
            //               color: ColorConstant.TextThreeColor,
            //             ),
            //             maxWidth: ScreenUtils.screenW(context) - 178.w)
            //         .height
            //         .h,
            width: ScreenUtils.screenW(context) - 64.w,
            decoration: new BoxDecoration(
              color: ColorConstant.TextFildBackColor,
              borderRadius: BorderRadius.all(Radius.circular(8.h)),
              //设置四周边框
              // border: new Border.all(width: 1, color: ColorConstant.WhiteColor),
            ),
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 19.h, left: 16.w),
                        height: 22.h,
                        width: 80.w,
                        child: Text(
                          "收件人：",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.TextSecondColor,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 19.h, right: 16.w),
                        height: 22.h,
                        width: ScreenUtils.screenW(context) - 178.w,
                        child: Text(
                          "周子芳",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.TextThreeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16.w),
                        height: 22.h,
                        width: 80.w,
                        child: Text(
                          "电话：",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.TextSecondColor,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 16.w),
                        height: 22.h,
                        width: ScreenUtils.screenW(context) - 178.w,
                        child: Text(
                          "0791-88829758",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.TextThreeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16.w),
                        height: boundingTextSize(
                                sendBackText,
                                TextStyle(
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.TextThreeColor,
                                ),
                                maxWidth: ScreenUtils.screenW(context) - 178.w)
                            .height
                            .h,
                        width: 80.w,
                        child: Text(
                          "收货地址：",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: ColorConstant.TextSecondColor,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 16.w),
                        height: boundingTextSize(
                                sendBackText,
                                TextStyle(
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.TextThreeColor,
                                ),
                                maxWidth: ScreenUtils.screenW(context) - 178.w)
                            .height
                            .h,
                        width: ScreenUtils.screenW(context) - 178.w,
                        child: Text(
                          sendBackText,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.TextThreeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16.w, bottom: 15.h),
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
                      Container(
                        margin: EdgeInsets.only(right: 16.w, bottom: 15.h),
                        height: 22.h,
                        width: ScreenUtils.screenW(context) - 178.w,
                        child: Text(
                          "到付即可",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.TextThreeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///底部View
  Widget atOnceOrder(BuildContext context) {
    return Container(
        // margin: EdgeInsets.only(top: 40.h, left: 24.w, right: 24.w,),
        margin: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 57.h),
        height: 55.h,
        child: OutlinedButton(
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(width: 0, color: ColorConstant.WhiteColor)),
                backgroundColor: MaterialStateProperty.all(isCanOrder
                    ? ColorConstant.MainBlueColor
                    : ColorConstant.WhiteColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.h)))),
            onPressed: () {},
            child: Container(
              child: Center(
                child: Container(
                  child: Text(
                    "立即预约",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: isCanOrder
                          ? ColorConstant.WhiteColor
                          : ColorConstant.Text_8E9AB,
                    ),
                  ),
                ),
              ),
            )));
  }

  static Size boundingTextSize(String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text == null || text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  void selectTime() {
    showSelectPickerTool(context, (timeStr) {
      sendBackTime = timeStr;
      print(sendBackTime);
      setState(() {});
    });
  }

  String initProvince = '', initCity = '', initTown = '';
  String sendBackAddress = "";
  String sendBackTime = "";

  void selectAddress() {
    Pickers.showAddressPicker(
      context,
      initProvince: initProvince,
      initCity: initCity,
      initTown: initTown,
      addAllItem: false,
      onConfirm: (p, c, t) {
        setState(() {
          initProvince = p;
          initCity = c;
          initTown = t;
          sendBackAddress = p + c + t;
        });
      },
    );
  }

  @override
  Future rightBtnTap(BuildContext context) {
    print(123);
  }
}
