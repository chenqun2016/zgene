import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/navigator/navigator_util.dart';
import 'package:zgene/pages/home/home_getHttp.dart';
import 'package:zgene/pages/home/video_page.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

class VideoNav extends StatefulWidget {
  @override
  _VideoNavState createState() => _VideoNavState();
}

class _VideoNavState extends State<VideoNav> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  List aloneList = [];

  @override
  void initState() {
    super.initState();
    HomeGetHttp(12, (result) {
      ContentModel contentModel = ContentModel.fromJson(result);
      aloneList.clear();
      setState(() {
        aloneList = contentModel.archives;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (aloneList.length == 0) {
      return Text("");
    } else {
      print(CommonUtils.splicingUrl(aloneList[0].imageUrl));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 24, left: 15),
            child: Text(
              "解锁独一无二的你",
              style: TextStyle(
                  fontSize: 18,
                  color: ColorConstant.TextMainBlack,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FractionallySizedBox(
            //撑满父布局的宽度
            widthFactor: 1,
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: GestureDetector(
                onTap: () {
                  NavigatorUtil.push(
                      context, VideoPage(linkUrl: aloneList[0].linkUrl));
                },
                child: PhysicalModel(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/home/img_default2.png',
                      image: CommonUtils.splicingUrl(aloneList[0].imageUrl),
                      height: 168,
                      fadeInDuration: TimeUtils.fadeInDuration(),
                      fadeOutDuration: TimeUtils.fadeOutDuration(),
                      fit: BoxFit.fill,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/home/img_default2.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                        );
                      }),
                  // Image.asset(
                  //   "assets/images/banner.png",
                  //   height: 168,
                  //   fit: BoxFit.fill,
                  // ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: _item(context, 1),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: _item(context, 2),
                )
              ],
            ),
          )
        ],
      );
    }
  }

  _item(BuildContext context, int index) {
    if (index > (aloneList.length - 1)) {
      return Text("");
    } else {
      Archives archives = aloneList[index];
      return GestureDetector(
        onTap: () {
          CommonUtils.toUrl(
              context: context, type: archives.linkType, url: archives.linkUrl);
        },
        child: Container(
          height: 153,
          margin: EdgeInsets.only(top: 17),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(
                    CommonUtils.splicingUrl(aloneList[index].imageUrl))),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            //
            // image: DecorationImage(
            //     fit: BoxFit.fill,
            //     image: index % 2 == 0
            //         ? AssetImage("assets/images/home/img_jiyinjieguo.png")
            //         : AssetImage("assets/images/home/img_jiyinjieguo2.png")),
            // borderRadius: BorderRadius.all(
            //   Radius.circular(10),
            // ),
          ),
          child: Text(
            archives.title,
            style: TextStyle(
                fontSize: 16,
                color: index % 2 == 0
                    ? ColorConstant.Text_776359
                    : ColorConstant.Text_64747F,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
