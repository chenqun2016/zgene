import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/common_constant.dart';
import 'package:zgene/event/event_bus.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/pages/home/explore_nav.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/pages/home/local_nav.dart';
import 'package:zgene/pages/home/problem_nav.dart';
import 'package:zgene/pages/home/video_nav.dart';
import 'package:zgene/util/base_widget.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/refresh_config_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const APPBAR_SCROLL_OFFSET = 50;

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
  EasyRefreshController _easyController;

  //首页banner
  List bannerList = [];

  ScrollController _controller = new ScrollController();

  @override
  void pageWidgetInitState() {
    UiUitls.setBlackTextStatus();

    showBaseHead = false;
    showHead = false;
    isListPage = true;
    setWantKeepAlive = true;
    backImgPath = "assets/images/home/bg_home.png";

    _easyController = EasyRefreshController();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      _onScroll(_controller.offset);
    });

    super.pageWidgetInitState();
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget viewPageBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: EasyRefresh(
            // 是否开启控制结束加载
            enableControlFinishLoad: false,
            firstRefresh: true,
            // 控制器
            controller: _easyController,
            header: RefreshConfigUtils.classicalHeader(),
            child: _listView,
            //下拉刷新事件回调
            onRefresh: () async {
              // page = 1;
              // // 获取数据
              // getHttp();
              getHttp();
              // await Future.delayed(Duration(seconds: 1), () {
              // 重置刷新状态 【没错，这里用的是resetLoadState】
              if (_easyController != null) {
                _easyController.resetLoadState();
              }
              // });
            },
          ),
        ),
        // RefreshIndicator(
        //     onRefresh: _handleRefresh,
        //     child: _listView),
        _appBar
      ],
    );
  }

  getHttp() {
    HomeGetHttp(10, (result) {
      ContentModel contentModel = ContentModel.fromJson(result);
      bannerList.clear();
      setState(() {
        bannerList = contentModel.archives;
      });
    });
    bus.emit(CommonConstant.HomeRefush);
  }

  Widget get _listView {
    return ListView(
      controller: _controller,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 0, bottom: 40),
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
        loop: false,
        itemWidth: double.infinity,
        itemHeight: 168,
        itemBuilder: (BuildContext context, int index) {
          Archives archives = bannerList[index];
          return GestureDetector(
            onTap: () {
              CommonUtils.toUrl(
                  context: context,
                  type: archives.linkType,
                  url: archives.linkUrl);
              // String model = bannerList[index];
              // NavigatorUtil.push();
            },
            // child: Image.network(
            //   bannerList[index],
            //   fit: BoxFit.fill,
            // ),
            child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/home/img_default2.png',
                image: CommonUtils.splicingUrl(archives.imageUrl),
                fadeInDuration: TimeUtils.fadeInDuration(),
                fadeOutDuration: TimeUtils.fadeOutDuration(),
                fit: BoxFit.fill,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/home/img_default2.png',
                    width: double.infinity,
                    height: 168,
                    fit: BoxFit.fill,
                  );
                }),
            // child: Image.asset(
            //   "assets/images/banner.png",
            //   height: 168,
            //   fit: BoxFit.fill,
            // ),
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

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    if (appBarAlpha != alpha) {
      setState(() {
        appBarAlpha = alpha;
      });
    }
  }
}
