import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/pages/home/explore_nav.dart';
import 'package:zgene/pages/home/local_nav.dart';
import 'package:zgene/pages/home/problem_nav.dart';
import 'package:zgene/util/ui_uitls.dart';

const APPBAR_SCROLL_OFFSET = 100;

///首页
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  double appBarAlpha = 0;

  //首页banner
  List<String> bannerList = [];

  @override
  void initState() {
    super.initState();
    UiUitls.setBlackTextStatus();
    bannerList.add("");
    bannerList.add("");
    bannerList.add("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Stack(
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
      ),
    );
  }

  Widget get _listView {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: ListView(
        children: [
          _title,
          _banner,
          LocalNav(),
          ExploreNav(),
          ProblemNav(),
        ],
      ),
    );
  }

  Widget get _title {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 13),
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
      height: 168,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              String model = bannerList[index];
              // NavigatorUtil.push();
            },
            // child: Image.network(
            //   bannerList[index],
            //   fit: BoxFit.fill,
            // ),
            child: Image.asset("assets/images/banner.png"),
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
        padding: EdgeInsets.only(top: 30),
        height: 70,
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
          "Z基因",
          style: TextStyle(
              fontSize: 18,
              color: ColorConstant.TextMainBlack,
              fontWeight: FontWeight.bold),
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
