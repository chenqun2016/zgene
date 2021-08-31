import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zgene/util/ui_uitls.dart';

const APPBAR_SCROLL_OFFSET = 100;
const APPBAR_SCROLL_OFFSET2 = 400;

///首页购买页面
class BuyPage extends BaseWidget {
  @override
  _BuyPageState getState() => _BuyPageState();
}

class _BuyPageState extends BaseWidgetState<BuyPage> {
  double appBarAlpha = 0;
  bool showBuyButtom = false;

  @override
  void pageWidgetInitState() {
    showBaseHead = false;
    showHead = false;
    isListPage = true;
    setWantKeepAlive = true;
    backImgPath = "assets/images/mine/img_bg_my.png";
    super.pageWidgetInitState();
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [_listview, _appBar],
    );
  }

  Widget get _listview {
    return NotificationListener(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification &&
            scrollNotification.depth == 0) {
          //滚动且是列表滚动的时候
          _onScroll(scrollNotification.metrics.pixels);
        }
        return false;
      },
      child: ListView(
        padding: EdgeInsets.only(bottom: 30),
        children: [
          _title,
          _banner,
          _products,
          _picture,
        ],
      ),
    );
  }

  Widget get _banner {
    return Container(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero),
        child: Image.asset(
          "assets/images/buy/banner_zhutu.png",
          height: 192,
          width: 343,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget get _products {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ZGene检测标准版1.0",
            style: TextStyle(
              fontSize: 22.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: ColorConstant.TextMainBlack,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 16),
            child: Text(
              "全面了解自己和家人的基因,只需要1分钟在家釆样,您就可以轻松在家获取个人基因检测报告,足以解锁您的「出厂设置」",
              style: TextStyle(
                fontSize: 15.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorConstant.Text_5E6F88,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "¥799.20",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.Text_FC4C4E,
                  ),
                ),
                flex: 1,
              ),
              MaterialButton(
                minWidth: 142.w,
                height: 44.h,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: ColorConstant.TextMainColor,
                onPressed: () {
                  UiUitls.showToast("立即购买");
                },
                child: Text("立即购买",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget get _picture {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.only(top: 16),
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Image.asset(
            "assets/images/buy/buy_banner.png",
            height: 81.h,
            width: 344.w,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            height: 1000,
          )
        ],
      ),
    );
  }

  Widget get _title {
    return Container(
      margin: EdgeInsets.only(
          left: 16, top: 10.w + MediaQuery.of(context).padding.top, bottom: 13),
      child: Text(
        "购买",
        style: TextStyle(
            fontSize: 24,
            color: ColorConstant.TextMainBlack,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget get _appBar {
    return Opacity(
      opacity: appBarAlpha,
      child: Container(
        color: Colors.white,
        height: 55.h + MediaQuery.of(context).padding.top,
        child: Stack(
          children: [
            Positioned(
              left: 80.w,
              right: 80.w,
              top: MediaQuery.of(context).padding.top,
              child: Container(
                height: 55.h,
                child: Center(
                  child: Text(
                    "购买",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.TextMainBlack,
                    ),
                  ),
                ),
              ),
            ),
            if (showBuyButtom)
              Positioned(
                  top: MediaQuery.of(context).padding.top,
                  right: 16.w,
                  child: Container(
                    height: 55.h,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        UiUitls.showToast("立即购买");
                      },
                      child: MaterialButton(
                        minWidth: 76.w,
                        height: 28.h,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: ColorConstant.TextMainColor,
                        onPressed: () {
                          UiUitls.showToast("立即购买");
                        },
                        child: Text("立即购买",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }

  _onScroll(offset) {
    print(offset);
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
      showBuyButtom = offset > APPBAR_SCROLL_OFFSET2;
    });
  }
}
