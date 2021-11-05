import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/widget/base_web.dart';

class ProblemNav extends StatefulWidget {
  @override
  _ProblemNavState createState() => _ProblemNavState();
}

class _ProblemNavState extends State<ProblemNav>
    with AutomaticKeepAliveClientMixin {
  // List<String> contents = ["关于基因检测。？", "基因检测的原理是什么？", "对用户隐私安全有什么保护措施？"];
  @override
  bool get wantKeepAlive => true;
  List contentList = [];

  @override
  void initState() {
    super.initState();
    // bus.on(CommonConstant.HomeRefush, (arg) {
    getHttp();
    // });
  }

  getHttp() {
    HomeGetHttp(3, (result) {
      print(result);
      ContentModel contentModel = ContentModel.fromJson(result);
      contentList.clear();
      setState(() {
        contentList = contentModel.archives;
      });
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    super.dispose();
    // bus.off(CommonConstant.HomeRefush);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "常见问题",
            style: TextStyle(
                fontSize: 18,
                color: ColorConstant.TextMainBlack,
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 40),
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(children: _items()),
          ),
        ],
      ),
    );
  }

  List<Widget> _items() {
    List<Widget> items = [];
    contentList.forEach((element) {
      if (contentList.indexOf(element) != 0) {
        items.add(Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Divider(),
        ));
      }

      items.add(_item(contentList.indexOf(element)));
    });
    return items;
  }

  Widget _item(index) {
    Archives archives = contentList[index];
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            BaseWebView(
                url: ApiConstant.getH5DetailUrl(archives.id.toString()),
                title: archives.title,
                showTitle: "常见问题"));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 10, right: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                archives.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    color: ColorConstant.TextMainBlack,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Image.asset(
              "assets/images/home/icon_to.png",
              height: 20,
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
