import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/constant/statistics_constant.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/umeng_utils.dart';

import 'home_getHttp.dart';

class ExploreNav extends StatefulWidget {
  @override
  _ExploreNavState createState() => _ExploreNavState();
}

class _ExploreNavState extends State<ExploreNav> {
  List tourList = [];

  @override
  void initState() {
    super.initState();
    // bus.on(CommonConstant.HomeRefush, (arg) {
    getHttp();
    // });
  }

  getHttp() {
    HomeGetHttp(11, (result) {
      ContentModel contentModel = ContentModel.fromJson(result);
      tourList.clear();
      setState(() {
        tourList = contentModel.archives;
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
      margin: EdgeInsets.only(top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "开启探索之旅",
              style: TextStyle(
                  fontSize: 18,
                  color: ColorConstant.TextMainBlack,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tourList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _item(index);
                }),
          )
        ],
      ),
    );
  }

  Widget _item(position) {
    Archives archives = tourList[position];
    return GestureDetector(
      onTap: () {
        UmengUtils.onEvent(StatisticsConstant.HOME_REPORT, {
          StatisticsConstant.KEY_UMENG_L2:
              StatisticsConstant.HOME_REPORT_01 + (position + 1).toString()
        });

        CommonUtils.toUrl(
            context: context,
            type: archives.linkType,
            url: archives.linkUrl,
            archives: archives);
      },
      child: Container(
          margin: EdgeInsets.only(left: 16, top: 10),
          width: 136,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 37),
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 14),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          archives.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorConstant.TextMainBlack,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        )),
                    Text(
                      archives.keywords,
                      style: TextStyle(
                          fontSize: 13, color: ColorConstant.Text_8E9AB),
                    )
                  ],
                ),
              ),
              new CachedNetworkImage(
                width: 90,
                // 设置根据宽度计算高度
                height: 90,
                // 图片地址
                imageUrl: CommonUtils.splicingUrl(archives.imageUrl),
                // 填充方式为cover
                fit: BoxFit.fill,

                errorWidget: (context, url, error) => new Container(
                  child: new Image.asset(
                    'assets/images/home/img_default2.png',
                    height: 90,
                    width: 90,
                  ),
                ),
              ),
              // FadeInImage.assetNetwork(
              //     placeholder: 'assets/images/home/img_default2.png',
              //     image: CommonUtils.splicingUrl(archives.imageUrl),
              //     width: 90,
              //     height: 90,
              //     fadeInDuration: TimeUtils.fadeInDuration(),
              //     fadeOutDuration: TimeUtils.fadeOutDuration(),
              //     fit: BoxFit.fill,
              //     imageErrorBuilder: (context, error, stackTrace) {
              //       return Image.asset(
              //         'assets/images/home/img_default2.png',
              //         width: 90,
              //         height: 90,
              //         fit: BoxFit.fill,
              //       );
              //     }),
            ],
          )),
    );
  }
}
