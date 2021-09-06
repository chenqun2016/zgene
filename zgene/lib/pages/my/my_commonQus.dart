import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/ui_uitls.dart';

class CommonQusListPage extends BaseWidget {
  @override
  BaseWidgetState getState() {
    return _CommonQusListPageState();
  }
}

class _CommonQusListPageState extends BaseWidgetState<CommonQusListPage> {
  List list = [];
  List tempList = [];
  int page = 1;
  int errorCode = 0; //0.正常 1.暂无数据 2.错误 3.没有网络
  var textStyle;

  @override
  void initState() {
    super.initState();
    pageWidgetTitle = "常见问题";
    backImgPath = "assets/images/mine/icon_commonQus_back.png";
    customRightBtnImg = "assets/images/mine/icon_commonQus_contant.png";
    isListPage = false;
    textStyle = TextStyle(
      fontSize: 15,
      color: Color(0xFF112950),
      fontWeight: FontWeight.w500,
    );
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return errorCode != 0
        ? UiUitls.getErrorPage(
            context: context,
            type: errorCode,
            onClick: () {
              // if (lastTime == null) {
              //   lastTime = DateTime.now();
              //   page = 1;
              //   getHttp();
              // } else {
              //   //可以点击
              //   if (TimeUtils.intervalClick(lastTime, 2)) {
              //     lastTime = DateTime.now();
              //     page = 1;
              //     getHttp();
              //   }
              // }
            })
        : Container(
            margin: EdgeInsets.fromLTRB(16.w, 17.h, 16.w, 17.h),
            // margin: EdgeInsets.only(left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: ColorConstant.WhiteColorB2,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: _listView,
          );
  }

  ///列表
  Widget get _listView {
    return Container(
      margin: EdgeInsets.all(0),
      width: double.infinity,
      child: ListView.builder(
        // controller: listeningController,
        itemCount: 5,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return getItem();
        },
      ),
    );
  }

  Widget getItem() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
      child: GestureDetector(
        onTap: () {
          // _onTapEvent(6);
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Container(
                width: double.infinity,
                height: 20,
                alignment: Alignment.centerLeft,
                child: Text(
                  "顺丰快递员拒绝收件?",
                  style: textStyle,
                )),
            Positioned(
              right: 0,
              top: 1.h,
              child: Image(
                image: AssetImage("assets/images/mine/icon_my_right.png"),
                height: 18,
                width: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
