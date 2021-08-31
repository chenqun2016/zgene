import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/pages/home/explore_nav.dart';
import 'package:zgene/pages/home/local_nav.dart';
import 'package:zgene/pages/home/problem_nav.dart';
import 'package:zgene/pages/home/video_nav.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const APPBAR_SCROLL_OFFSET = 100;

///首页
class HomePage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return _HomePageState();
  }
}

class _HomePageState extends BaseWidgetState<HomePage> {
  bool _loading = true;
  double appBarAlpha = 0;

  //首页banner
  List<String> bannerList = [];

  @override
  void pageWidgetInitState() {
    UiUitls.setBlackTextStatus();
    bannerList.add("");
    bannerList.add("");
    bannerList.add("");

    showBaseHead = false;
    showHead = false;
    isListPage = true;
    setWantKeepAlive = true;
    backImgPath = "assets/images/home/bg_home.png";
    super.pageWidgetInitState();
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
            onRefresh: _handleRefresh,
            child: NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.depth == 0) {
                  //滚动且是列表滚动的时候
                  _onScroll(scrollNotification.metrics.pixels);
                }
                return false;
              },
              child: _listView,
            )),
        _appBar
      ],
    );
  }

  Widget get _listView {
    return ListView(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      children: [
        _title,
        _banner,
        LocalNav(),
        ExploreNav(),
        VideoNav(),
        ProblemNav(),
      ],
    );
  }

  Widget get _title {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 20, bottom: 13),
      child: Text(
        "Z基因",
        style: TextStyle(
            fontSize: 24,
            color: ColorConstant.TextMainBlack,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget get _banner {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      height: 168,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // String model = bannerList[index];
              // NavigatorUtil.push();
            },
            // child: Image.network(
            //   bannerList[index],
            //   fit: BoxFit.fill,
            // ),
            child: Image.asset(
              "assets/images/banner.png",
              height: 168,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
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
                    "Z基因",
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
          ],
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    try {
      setState(() {
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
  }
}
