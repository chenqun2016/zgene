import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zgene/constant/api_constant.dart';
import 'package:zgene/constant/color_constant.dart';
import 'package:zgene/http/http_utils.dart';
import 'package:zgene/models/content_model.dart';
import 'package:zgene/util/common_utils.dart';
import 'package:zgene/util/time_utils.dart';
import 'package:zgene/util/ui_uitls.dart';

class ExploreNav extends StatefulWidget {
  @override
  _ExploreNavState createState() => _ExploreNavState();
}

class _ExploreNavState extends State<ExploreNav> {

  List tourList=[];

  @override
  void initState() {
    super.initState();
    getHttp(11);
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
    return Container(
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
                            fontWeight: FontWeight.bold),
                      )),
                  Text(
                    archives.keywords,
                    style: TextStyle(
                        fontSize: 13, color: ColorConstant.Text_8E9AB),
                  )
                ],
              ),
            ),
            FadeInImage.assetNetwork(
                placeholder: 'assets/images/home/img_default2.png',
                image: CommonUtils.splicingUrl(archives.imageUrl),
                width: 90,
                height: 90,
                fadeInDuration: TimeUtils.fadeInDuration(),
                fadeOutDuration: TimeUtils.fadeOutDuration(),
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/home/img_default2.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.fill,
                  );
                }),
          ],
        ));
  }

  ///获取内容列表
  getHttp(type) async {
    bool isNetWorkAvailable = await CommonUtils.isNetWorkAvailable();
    if (!isNetWorkAvailable) {
      return;
    }
    Map<String, dynamic> map = new HashMap();
    map['cid'] =type;//栏目ID 9:金刚区 10:Banner 11:探索之旅 12:独一无二的你 3:常见问题 6:示例报告（男） 7:示例报告（女） 15：精选报告
    HttpUtils.requestHttp(
      ApiConstant.contentList,
      parameters: map,
      method: HttpUtils.GET,
      onSuccess: (result) async {
        ContentModel contentModel = ContentModel.fromJson(result);
        tourList.clear();
        setState(() {
          tourList=contentModel.archives;
        });

      },
      onError: (code, error) {
        UiUitls.showToast(error);
      },
    );
  }
}
