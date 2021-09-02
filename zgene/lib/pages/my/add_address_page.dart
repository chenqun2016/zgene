import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

class AddAddressPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return AddAddressPageState();
  }
}

class AddAddressPageState extends BaseWidgetState<AddAddressPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _areaController = new TextEditingController();

  @override
  void pageWidgetInitState() {
    pageWidgetTitle = "添加收货地址";
    backImgPath = "assets/images/mine/img_bg_my.png";
    super.pageWidgetInitState();
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, left: 15, right: 15),
          width: double.infinity,
          padding: EdgeInsets.only(left: 19, right: 19),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            color: Colors.white70,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              TextField(
                  controller: _nameController,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.TextMainBlack,
                      fontSize: 15),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstant.bg_E5E7F3),
                    ),
                    //获得焦点下划线设为蓝色
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstant.bg_E5E7F3),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(15, 25, 0, 25),
                    isCollapsed: true,
                    hintText: "请输入姓名",
                    hintMaxLines: 1,
                    hintStyle: TextStyle(
                        color: ColorConstant.Text_9395A4,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    prefixIcon: Text(
                      "收货人",
                      style: TextStyle(
                          color: ColorConstant.TextMainBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 80, minHeight: 0),
                  )),
              TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _phoneController,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.TextMainBlack,
                      fontSize: 15),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstant.bg_E5E7F3),
                    ),
                    //获得焦点下划线设为蓝色
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstant.bg_E5E7F3),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(15, 25, 0, 25),
                    isCollapsed: true,
                    hintText: "请输入手机号",
                    hintMaxLines: 1,
                    hintStyle: TextStyle(
                        color: ColorConstant.Text_9395A4,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    prefixIcon: Text(
                      "手机号",
                      style: TextStyle(
                          color: ColorConstant.TextMainBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 80, minHeight: 0),
                  )),
              Stack(children: [
                TextField(
                    enableInteractiveSelection: false,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    controller: _cityController,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.TextMainBlack,
                        fontSize: 15),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorConstant.bg_E5E7F3),
                      ),
                      //获得焦点下划线设为蓝色
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorConstant.bg_E5E7F3),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(15, 25, 0, 25),
                      isCollapsed: true,
                      hintText:
                          sendBackAddress == "" ? "请选择所在地区" : sendBackAddress,
                      hintMaxLines: 1,
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
                      prefixIcon: Text(
                        "所在地区",
                        style: TextStyle(
                            color: ColorConstant.TextMainBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 80, minHeight: 0),
                    )),
                Positioned(
                  top: 23.h,
                  right: 20.w,
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
              TextField(
                  controller: _areaController,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.TextMainBlack,
                      fontSize: 15),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(15, 25, 0, 25),
                    isCollapsed: true,
                    hintText: "选择填写详细地址",
                    hintMaxLines: 1,
                    hintStyle: TextStyle(
                        color: ColorConstant.Text_9395A4,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    prefixIcon: Text(
                      "详细地址",
                      style: TextStyle(
                          color: ColorConstant.TextMainBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 80, minHeight: 0),
                  ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 60),
          child: MaterialButton(
            height: 55,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            minWidth: 328,
            disabledColor: Colors.white,
            color: ColorConstant.TextMainColor,
            onPressed: () {
              if (canNext) {
                addAddressHttp();
              }
            },
            child: Text("保存",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: canNext ? Colors.white : ColorConstant.Divider,
                )),
          ),
        )
      ],
    );
  }

  bool get canNext {
    return _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        sendBackAddress.isNotEmpty &&
        _areaController.text.isNotEmpty;
  }

  String initProvince = '', initCity = '', initTown = '';
  String sendBackAddress = "";
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

  void addAddressHttp() async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }
    EasyLoading.show(status: 'loading...');

    Map<String, dynamic> map = new HashMap();
    map['province'] = initProvince;
    map['city'] = initCity;
    map['Town'] = initTown;
    map['address'] = _areaController.text;
    map['rcv_name'] = _nameController.text;
    map['rcv_phone'] = _phoneController.text;

    HttpUtils.requestHttp(
      ApiConstant.userAddAddress,
      parameters: map,
      method: HttpUtils.POST,
      onSuccess: (result) async {
        print(result);
        EasyLoading.showSuccess("添加成功");
        //1为刷新页面
        Navigator.pop(context, 1);
      },
      onError: (code, error) {
        EasyLoading.showError(error);
      },
    );
  }
}
